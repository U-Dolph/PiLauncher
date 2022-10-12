import inputs
from PyQt5.QtCore import QObject, pyqtSlot, pyqtProperty, Qt, pyqtSignal

EVENT_ABB = (
    # D-PAD
    ('Absolute-ABS_HAT0X', 'HX'),
    ('Absolute-ABS_HAT0Y', 'HY'),

    # Face Buttons
    ('Key-BTN_NORTH', 'N'),
    ('Key-BTN_EAST', 'E'),
    ('Key-BTN_SOUTH', 'S'),
    ('Key-BTN_WEST', 'W'),

    # Other buttons
    ('Key-BTN_MODE', 'M'),
    ('Key-BTN_START', 'ST'),
)

class ControllerManager:
    def __init__(self, gamepad=inputs.devices.gamepads[0], abbrevs=EVENT_ABB, signal=None):
        self.abbrevs = dict(abbrevs)
        self.gamepad = gamepad
        self.signal = signal

    def process_event(self, event):
        if event.ev_type == 'Sync' or event.ev_type == 'Misc':
            return

        key = event.ev_type + '-' + event.code

        try:
            abbv = self.abbrevs[key]
        except:
            return
                
        # print(abbv, event.state)
        self.signal.emit(abbv, event.state)

    def process_events(self):
        events = self.gamepad.read()

        for event in events:
            self.process_event(event)

    def poll(self):
        while 1:
            self.process_events()

