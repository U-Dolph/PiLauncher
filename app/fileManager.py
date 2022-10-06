import os, json
from json import JSONEncoder
import subprocess

home_dir = os.path.expanduser('~')
print(home_dir)


class CustomEncoder(JSONEncoder):
    def default(self, o):
        return o.__dict__


class FileManager:
    def __init__(self):
        self.pre_check()


    def pre_check(self):
        if not os.path.exists(os.path.join(home_dir, "games")):
            os.mkdir(os.path.join(home_dir, "games"))
        
        if not os.path.exists(os.path.join(home_dir, "games", "games.catalog")):
            with open(os.path.join(home_dir, "games", "games.catalog"), "w+") as file:
                json.dump({"games": []}, file, indent=4)


    def get_games(self):
        with open(os.path.join(home_dir, "games", "games.catalog"), "r") as file:
            data = json.load(file)

            result = []

            for game in data["games"]:
                result.append(game)

            return result


    def get_game_by_id(self, _id):
        with open(os.path.join(home_dir, "games", "games.catalog"), "r") as file:
            data = json.load(file)

            for game in data["games"]:
                if game['id'] == _id:
                    return game

            return None
    

    def save_game(self, raw, game):
        with open(os.path.join(home_dir, "games", game['filePath']), "wb+") as file:
            file.write(raw)

        with open(os.path.join(home_dir, "games", "games.catalog"), "r+") as file:
            data = json.load(file)

            for idx, localGame in enumerate(data['games']):
                if game['id'] == localGame['id']:
                    print('updating')
                    data['games'][idx] = {"name": game['name'], "id": game['id'], "version": game['version'], "description": game['description'], "location": game['filePath']}

                    file.seek(0)
                    json.dump(data, file, indent=4)

                    return

            data['games'].append({"name": game['name'], "id": game['id'], "version": game['version'], "description": game['description'], "location": game['filePath']})

            file.seek(0)
            json.dump(data, file, indent=4)

    
    def launch_game(self, game):
        subprocess.run(["love", os.path.join(home_dir, "games", game['location'])])
