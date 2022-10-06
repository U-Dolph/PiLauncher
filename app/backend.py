from PyQt5.QtGui import QStandardItemModel, QStandardItem
from PyQt5.QtCore import QObject, pyqtSlot, pyqtProperty, Qt, pyqtSignal
import PyQt5.QtCore as QtCore
import app.fileManager as fm
import app.networkService as ns
import json

NAME_ROLE = Qt.UserRole
LIST_ID_ROLE = Qt.UserRole + 1
GAME_ID = Qt.UserRole + 2
GAME_VERSION = Qt.UserRole + 3

NEEDS_UPDATE = Qt.UserRole + 99 # place it far away from the others
STORE_STATE = Qt.UserRole + 100


class Backend(QObject):
    downloadProgress = pyqtSignal(int, int, int, arguments=["total", "progress", "actualId"])

    def __init__(self, application):
        QObject.__init__(self)
        self.app = application

        with open('config.json') as f:
            config = json.load(f)

        self.file_manager = fm.FileManager()
        self.network_service = ns.NetworkService(config)
        self.network_service.get_games_list()

        self._libraryModel = QStandardItemModel()
        self._libraryModel.setItemRoleNames(
            {
                NAME_ROLE: b"name",
                LIST_ID_ROLE: b"listId",
                GAME_ID: b"gameId",
                GAME_VERSION: b"version",
                NEEDS_UPDATE: b"needsUpdate"
            }
        )

        self._storeModel = QStandardItemModel()
        self._storeModel.setItemRoleNames(
            {
                NAME_ROLE: b"name",
                LIST_ID_ROLE: b"listId",
                GAME_ID: b"gameId",
                GAME_VERSION: b"version",
                STORE_STATE: b"gameState"
            }
        )


    def add_local_row(self, name, list_id, game_id, version, needsUpdate):
        item = QStandardItem()
        item.setData(name, NAME_ROLE)
        item.setData(list_id, LIST_ID_ROLE)
        item.setData(game_id, GAME_ID)
        item.setData(version, GAME_VERSION)
        item.setData(needsUpdate, NEEDS_UPDATE)

        self._libraryModel.appendRow(item)


    def add_store_row(self, name, list_id, game_id, version, state):
        item = QStandardItem()
        item.setData(name, NAME_ROLE)
        item.setData(list_id, LIST_ID_ROLE)
        item.setData(game_id, GAME_ID)
        item.setData(version, GAME_VERSION)
        item.setData(state, STORE_STATE)

        self._storeModel.appendRow(item)

    
    @pyqtProperty(QObject, constant=True)
    def libraryModel(self):
        return self._libraryModel


    @pyqtProperty(QObject, constant=True)
    def storeModel(self):
        return self._storeModel


    @pyqtSlot(bool)
    def buttonAPressed(self, val):
        if val:
            print('A pressed')
        else:
            print('A released')


    @pyqtSlot(int)
    def navigationChanged(self, selected):
        menu_column = self.app.root.findChild(QtCore.QObject, "menuColumn")
        
        for idx, x in enumerate(menu_column.children()):
            if selected == idx:
                x.setProperty('isActive', True)
            else:
                x.setProperty('isActive', False)


    @pyqtSlot()
    def getLocalGames(self):
        self._libraryModel.clear()

        games = self.file_manager.get_games()

        for idx, game in enumerate(games):
            is_update_available = self.check_for_update(game['id'])
            self.add_local_row(game["name"], idx, game["id"], game["version"], is_update_available)


    @pyqtSlot()
    def getOnlineGames(self):
        self._storeModel.clear()

        games = self.network_service.get_games_list()

        for idx, game in enumerate(games):
            is_installed = self.check_if_installed(game['id'])
            is_update_available = False
            
            if is_installed:
                is_update_available = self.check_for_update(game['id'])

            self.add_store_row(game["name"], idx, game["id"], game["version"], "Update available" if is_update_available else "Installed" if is_installed else "")


    @pyqtSlot(int)
    def getStoreGame(self, index):
        item = self._storeModel.item(index, 0)
        game = self.network_service.get_game_by_id(item.data(GAME_ID))

        is_installed = self.check_if_installed(game['id'])
        
        if not is_installed:
            raw = self.network_service.download_game(game, self.downloadProgress)
            self.file_manager.save_game(raw, game)

        else:
            is_update_available = self.check_for_update(game['id'])

            if is_update_available:
                raw = self.network_service.download_game(game, self.downloadProgress)
                self.file_manager.save_game(raw, game)

    def check_if_installed(self, _id):
        installed_games = self.file_manager.get_games()

        for game in installed_games:
            if game['id'] == _id:
                return True

        return False

    def check_for_update(self, _id):
        onlineGame = self.network_service.get_game_by_id(_id)
        localGame = self.file_manager.get_game_by_id(_id)

        if onlineGame['version'] != localGame['version']:
            return True

        return False
