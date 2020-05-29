import cv2
import dlib

cv2.__version__
predictor_path = "/usr/src/files/shape_predictor_68_face_landmarks.dat"
predictor = dlib.shape_predictor(predictor_path)
