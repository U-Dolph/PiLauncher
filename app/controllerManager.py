import inputs
from PyQt5.QtCore import QObject, pyqtSlot, pyqtProperty, Qt, pyqtSignal

EVENT_ABB = (
    # D-PAD
    ('Absolute-ABS_HAT0X', 'HX'),
    ('Absolute-ABS_HAT0Y', 'HY'),

    # Face Buttons
    ('Key-BTN_NORTH', 'Y'),
    ('Key-BTN_EAST', 'B'),
    ('Key-BTN_SOUTH', 'A'),
    ('Key-BTN_WEST', 'X'),

    # Other buttons
    ('Key-BTN_MODE', 'SEL'),
    ('Key-BTN_START', 'STR'),
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
                
        self.signal.emit(abbv, event.state)

    def process_events(self):
        events = self.gamepad.read()

        for event in events:
            self.process_event(event)

    def poll(self):
        while 1:
            self.process_events()

