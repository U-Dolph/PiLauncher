import sys

from app import backend, app

if __name__ == '__main__':
    launcher = app.Application(sys.argv)
    
    launcher.run()