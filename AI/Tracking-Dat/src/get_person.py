import os
import time
import pickle
from src.color_utils import find_person_images



if __name__ == "__main__":
    scene = "S003"
    cfg, images, cam_person_infor, unique_person_id = utils._initialize("src/web_app/configs/app.yaml", scene)

    s = time.time()
    print("Finding person images...")
    find_person_images(unique_person_id, COLOR['YELLOW'], 60, 2)
    e = time.time() 
    print("Done finding person images. Time:", e - s, "s")