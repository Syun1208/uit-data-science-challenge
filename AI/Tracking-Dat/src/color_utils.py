from sklearn.cluster import KMeans, MiniBatchKMeans
import numpy as np
import cv2 
from collections import Counter 
from skimage.color import rgb2lab, deltaE_cie76, deltaE_ciede94, deltaE_ciede2000
from src.utils import get_image, save_image
import time
from src.color_catergory import COLOR


def get_colors(image, number_of_colors):
    
    modified_image = cv2.resize(image, (600, 400), interpolation = cv2.INTER_AREA)
    modified_image = modified_image.reshape(modified_image.shape[0]*modified_image.shape[1], 3)
    
    
    # clf = KMeans(n_clusters = number_of_colors)
    #Using MiniBatchKMeans to acclelerate the process
    clf = MiniBatchKMeans(n_clusters = number_of_colors,
                          batch_size= 256*6)
    
    labels = clf.fit_predict(modified_image)
    
    counts = Counter(labels)
    # sort to ensure correct color percentage
    counts = dict(sorted(counts.items()))
    
    center_colors = clf.cluster_centers_
    # We get ordered colors by iterating through the keys
    ordered_colors = [center_colors[i] for i in counts.keys()]
    # hex_colors = [RGB2HEX(ordered_colors[i]) for i in counts.keys()]
    rgb_colors = [ordered_colors[i] for i in counts.keys()]

    return rgb_colors

def match_image_by_color(image, colors, threshold = 45, number_of_colors = 3): 
    image_colors = get_colors(image, number_of_colors)
    def custom_rgb2lab(colors):
        convert_colors = []
        for color in colors: 
            convert_colors.append(rgb2lab(np.uint8(np.asarray([[color]]))))
        return convert_colors
    
    selected_colors = custom_rgb2lab(colors)

    
    select_image = False
    for i in range(number_of_colors):
        curr_color = rgb2lab(np.uint8(np.asarray([[image_colors[i]]])))
        for j in range(len(selected_colors)):
            diff = deltaE_cie76(selected_colors[j], curr_color)
            # diff = deltaE_ciede94(selected_colors[j], curr_color, kH=1, kC=1, kL=1, k1=0.045, k2=0.015)
            if (diff < threshold):
                select_image = True
    return select_image

def find_person_images(unique_person_id: dict, colors: list, threshold, colors_to_match):
    index = 0
    # unique_person_id: dict of unique person id
    #         unique_person_id = {
    #                 "person_id": {
    #                     "cam": []
    #                     "person_image": []
    #@                     "frame_id": []
    #                 }
    #             }
    chosen_person_image_path = []
    for person_id in unique_person_id:
        for i in range(len(unique_person_id[person_id]["person_image"])):
                print("Matching image of person_id:", person_id, "...")
                image  = unique_person_id[person_id]["person_image"][i]
                selected = match_image_by_color(image,
                                                colors,
                                                threshold,
                                                colors_to_match)
                if (selected):
                    cam_id = unique_person_id[person_id]["cam_id"][i]
                    frame_id = unique_person_id[person_id]["frame_id"][i]
                    save_path = f"temp/{index}.jpg"
                    save_image(image, save_path)
                    chosen_person_image_path.append((save_path, cam_id, person_id,frame_id))
                    index += 1
    if (index == 0):
        print("No image found")
    else: 
        print("Found", index, "person images")
    return chosen_person_image_path


def getPersonByColor(person_image_dict, colors: list):
    colors = [COLOR[color.upper()] for color in colors]
    s = time.time()
    print("Finding person images...")
    chosen_image_paths = find_person_images(person_image_dict, colors, 40, 4)
    e = time.time() 
    print("Done finding person images. Time:", e - s, "s")
    prompt = "Found " + str(len(chosen_image_paths)) + " images. Time: " + str(round(e - s,2)) + " seconds"
    return chosen_image_paths, prompt