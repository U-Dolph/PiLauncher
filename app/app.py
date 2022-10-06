import sys, os

from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtCore import QUrl
import app.backend as be

base_directory = os.path.dirname(os.path.abspath(__file__))

class Application(QGuiApplication):
    def __init__(self, args):
        super(Application, self).__init__(args)

        self.backend = be.Backend(self)

        self.engine = QQmlApplicationEngine()
        
        self.engine.quit.connect(self.quit)
        self.engine.rootContext().setContextProperty("backend", self.backend)
        self.engine.load(QUrl.fromLocalFile(os.path.join(base_directory, "views", 'Base.qml')))

        self.root = self.engine.rootObjects()[0]


    def run(self):
        sys.exit(self.exec())