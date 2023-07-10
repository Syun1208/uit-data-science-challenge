import pickle
import os
from collections import defaultdict
from functools import partial

scene = "S009"
pkl_folder = r"D:/TaiLieuHocTap/TaiLieuMonHoc/DATN_2/source/app/mtmt_app/assets/cam/temp"
unique_person_id = defaultdict(partial(defaultdict,list))

for pkl in os.listdir(pkl_folder):
    if not pkl.endswith(".pkl"):continue
    pkl_path = os.path.join(pkl_folder,pkl)
    unique_person_id_cam = pickle.load(open(pkl_path, "rb"))
    for person_id in unique_person_id_cam:
        unique_person_id[person_id]["cam_id"] += unique_person_id_cam[person_id]["cam_id"]
        unique_person_id[person_id]["person_image"] += unique_person_id_cam[person_id]["person_image"]
        unique_person_id[person_id]["frame_id"] += unique_person_id_cam[person_id]["frame_id"]
pickle.dump(unique_person_id, open(os.path.join(pkl_folder,f"{scene}.pkl"), "wb"))