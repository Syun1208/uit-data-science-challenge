import yaml 
import cv2
import os
import time
from src.detection import Detection
from threading import Thread
from collections import defaultdict
# from turbojpeg import TurboJPEG
import pickle
from functools import partial

def load_config(config_path,print_config=True):
    with open(config_path, "r") as fid:
        cfg = yaml.safe_load(fid)
    #Print beautiful config
    if print_config:
        print("Config:")
        for key in cfg:
            print(key, ":", cfg[key])
    return cfg
    
def get_image(image_file): 
    image = cv2.imread(image_file)
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    return image

def load_images_cv2(cfg, image_folder):
    """
    Return: 
        images: dict of images
            images = {
                "frame_id" : image
                }
    """
    threads = []
    images = {}
    num_threads = cfg["PARAMS"]["NUM_THREADS"]
    print("Get images from folder: ", image_folder)
    image_paths = [os.path.join(image_folder, filename) for filename in (os.listdir(image_folder))]
    
    def read_image(image_path):
        frame_id = image_path.split("/")[-1].replace(".jpg", "")
        #Read BGR image
        image = cv2.imread(image_path)
        #Convert to RGB
        image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
        images[frame_id] = image
        
    # Define a function for each thread to read images
    def thread_function(thread_id, image_path):
        for i in range(thread_id, len(image_paths), num_threads):
            image_path = image_paths[i]
            read_image(image_path)
    
    print("Reading images with OpenCV...")
    s = time.time()
    # Create and start the threads
    for i in range(num_threads):
        thread = Thread(target=thread_function, args=(i, image_paths))
        thread.start() 
        threads.append(thread)

    # Wait for all threads to complete
    for thread in threads:
        thread.join()
    e = time.time()
    print("Done reading images. Time: {:02f}s".format(e-s))
    return images

def load_images(cfg, scene_folder, engine="turbojpeg"):
    """
    Return: 
        images: dict of images
            images = {
                "cam_id":{
                    "frame_id" : image
                }
            }
    """
    
    #Define input dictionary
    # scene_cam_image = {
    #     "cam_id": []
    # }
    
    threads = []
    images = defaultdict(dict)
    scene_cam_image = defaultdict(list)
    num_threads = cfg["PARAMS"]["NUM_THREADS"]
    print("Get images from scene: ", scene_folder)
    print("Get images from camera:",)
    num_cam = 2
    cam_counter = 0
    for cam_id in os.listdir(scene_folder): 
        if cam_counter == num_cam: break
        if "map" in cam_id: continue
        print("->",cam_id, end=" ")
        image_folder = os.path.join(scene_folder, cam_id, "img1")
        cam_id_in_dict = cam_id[1:]
        scene_cam_image[cam_id_in_dict] = [os.path.join(image_folder, image_file) for image_file in os.listdir(image_folder)]
        print("(Done!)")
        cam_counter += 1
    
    if engine == "turbojpeg":
        _engine = "TurboJPEG"
        jpeg = TurboJPEG() 
        def read_image(image_path):
            with open(image_path, "rb") as f:
                #Read BGR image
                image = jpeg.decode(f.read())
            # Using for clear memory to debug time execution
            # image = None
            return image

    elif engine == "opencv":
        _engine = "OpenCV"
        def read_image(image_path):
            #Read BGR image
            image = cv2.imread(image_path)
            return image

    def read_images_for_cam(thread_id, cam_id, image_paths):
        cam_id = cam_id[1:].zfill(3)
        for i in range(thread_id, len(image_paths), num_threads):
            image_file = image_paths[i]
            frame_id = image_file.split("/")[-1].replace(".jpg", "")
            image = read_image(image_file)
            # Store the image in the output dictionary
            images[cam_id][frame_id] = image
    
    print("Using",_engine,"engine to read images")
    s_all = time.time()

    for cam_id, image_paths in scene_cam_image.items():
        print(f"Reading {len(image_paths)} images from camera", cam_id,"...", end=" ")
        s_one = time.time()
        for thread_id in range(num_threads):
            thread = Thread(target=read_images_for_cam, args=(thread_id,cam_id, image_paths))
            thread.start()
            threads.append(thread)
            
        for thread in threads:
            thread.join()
    
        e_one = time.time()
        print(f"(Done!. Time: {e_one-s_one:.2f}s)")
        
    e_all = time.time()
    print("Done reading images. Time: {:02f}s".format(e_all-s_all))
    return images

def load_tracking_result(images: dict, tracking_file):
    """   
    Load tracking result from txt file
     
    Return: 
        cam_person_infor: dict of person image  
            cam_person_infor = {
                "cam": {
                    "frame_id": [
                        (person_id, person_bbox, person_image)
                    ]
                }
            }
    """
    # Multi-cam: f"{camera},{new_track_id},{frame_id},{x1},{y1},{w},{h},-1,-1\n"
    # cam_person_infor = defaultdict(lambda: defaultdict(list))
    cam_person_infor = defaultdict(partial(defaultdict,list))
    with open(tracking_file, "r") as f:
        for line in f.readlines():
            line = line.split(",")
            cam_id = line[0].zfill(3) 
            if cam_id not in images.keys(): continue # Skip cam_id not in scene
            person_id = line[1] #string
            frame_id = line[2].zfill(6)
            x = int(line[3])
            y = int(line[4])
            w = int(line[5])
            h = int(line[6])
            person_image = images[cam_id][frame_id][y:y+h, x:x+w]
            pack = (person_id, 
                    Detection([x, y, w, h]), 
                    person_image)
            
            cam_person_infor[cam_id][frame_id].append(pack)
    return cam_person_infor

def get_unique_person_id(cfg, cam_person_infor):
    """
    Return: 
        unique_person_id: dict of unique person id
            unique_person_id = {
                    "person_id": {
                        "cam_id": []
                        "person_image": []
                        "frame_id": []
                    }
                }
    """
    AREA_THRESHOLD = cfg["PARAMS"]["AREA_THRESHOLD"]
    # unique_person_id = defaultdict(lambda: defaultdict(list))
    unique_person_id = defaultdict(partial(defaultdict,list))
    for cam_id in cam_person_infor:
        for frame_id in cam_person_infor[cam_id]:
            for person_id, person_bbox, person_image in cam_person_infor[cam_id][frame_id]:
                if cam_id in unique_person_id[person_id]["cam_id"]: 
                    continue
                if person_bbox.area < AREA_THRESHOLD: 
                    continue
                
                unique_person_id[person_id]["cam_id"].append(cam_id)
                #Convert to RGB for matching color work properly
                person_image = cv2.cvtColor(person_image, cv2.COLOR_BGR2RGB)
                unique_person_id[person_id]["person_image"].append(person_image)
                unique_person_id[person_id]["frame_id"].append(frame_id)
    return unique_person_id

def save_image(image, image_path):
    image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)
    cv2.imwrite(image_path, image)

def draw_bbox(image, bbox):
    t, l, b, r = bbox
    image = cv2.rectangle(image, (t,l), (b,r), (0,255,0), 2)
    return image

def _debug():
    """
    Use for debug the unique_person_id or cam_person_infor
    """
    # index = 0
    # for person_id in unique_person_id:
    #     for person_image, cam_id in zip(unique_person_id[person_id]["person_image"],unique_person_id[person_id]["cam_id"]):
    #         save_image(person_image, f"/home/hoangtv/data/Phong_Dat/aic23/src/top2git/src/web_app/{index}.jpg")
    #         print("Index:",index,"Person ID:", person_id, "cam_id:", cam_id)
    #         index += 1

    # index = 0 
    # isBreak = False
    # for cam_id in cam_person_infor:
    #     if cam_id != "14": continue
    #     if isBreak: break
    #     isBreak = False 
    #     for frame_id in cam_person_infor[cam_id]: 
    #         if isBreak: break
    #         for person_id, person_bbox, person_image in cam_person_infor[cam_id][frame_id]:
    #             if person_id not in ["0","3","6","7"]: continue
    #             full_image = images[frame_id]
    #             full_image_with_bbox = draw_bbox(full_image, person_bbox.to_tlbr())
    #             print("Index:",index,"cam_id:", cam_id, "Frame:", frame_id, "Person id:", person_id, "Bbox:", person_bbox.tlwh)
    #             save_image(full_image_with_bbox, f"/home/hoangtv/data/Phong_Dat/aic23/src/top2git/src/web_app/{index}.jpg")
    #             index += 1
    #             if index == 100: 
    #                 isBreak = True
    #                 break            

def _test_unit(unique_person_id): 
    person_id_length = len(list(unique_person_id.keys()))
    print("Test person id length...",end=" ")
    if not 0 < person_id_length <= 8:
        print("person_id_length: ", person_id_length)
        print("(Failed!)")
    else: 
        print("(Passed!)")
    
    print("Test cam length...",end=" ")
    cam_test = "(Passed!))"
    for person_id in unique_person_id:
        curr_cam_length = len(unique_person_id[person_id]["cam_id"])
        if not 0 < curr_cam_length <= 6:
            print("Current camera list:", unique_person_id[person_id]["cam_id"])
            print("Current cam length:", curr_cam_length)
            cam_test = "(Failed!)"
            break
    print(cam_test)

def _initialize(config_path, scene):
    cfg = load_config(config_path,print_config=True)
    
    path = cfg["DATASET"]["TRACKING_RESULT"]
    ROOT_DATASET = cfg["DATASET"]["ROOT_DATASET"]
    
    file_path = os.path.join(path, f"{scene}.txt")
    scene_folder = os.path.join(ROOT_DATASET, f"{scene}")
    images = load_images(cfg, scene_folder, engine="turbojpeg")
    cam_person_infor = load_tracking_result(images,file_path)
    unique_person_id = get_unique_person_id(cfg,cam_person_infor)
    _test_unit(unique_person_id)

    return cfg, images, cam_person_infor, unique_person_id

    
if __name__ == "__main__": 
    scene = "S003"
    cfg, images, cam_person_infor, unique_person_id = _initialize("src/web_app/configs/app.yaml", scene)
    pickle.dump(cam_person_infor, open(f"src/web_app/S31916_cam_person_info.pkl", "wb"))
    pickle.dump(unique_person_id, open(f"src/web_app/S31916_unique_person_id.pkl", "wb"))

                    