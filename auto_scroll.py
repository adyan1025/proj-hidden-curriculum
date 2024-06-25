import pyautogui
import time

pyautogui.leftClick(500, 500, duration=2)
for i in range(50):
    time.sleep(1)
    pyautogui.press('down')
    print("Iterration: " + str(i+1))