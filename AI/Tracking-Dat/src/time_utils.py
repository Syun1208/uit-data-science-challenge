import time 
from datetime import datetime


def frame_to_seconds(frame):
    FRAME_RATE = 30
    return frame/FRAME_RATE

def time_with_offset(timestamp, offset):
    return timestamp + offset

def timestamp_to_readable(timestamp):
    dt = datetime.fromtimestamp(timestamp)
    formatted_time = dt.strftime("%d/%m/%Y %H:%M:%S")
    return formatted_time