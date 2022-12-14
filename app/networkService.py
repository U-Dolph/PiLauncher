import json
import requests
import io

class NetworkService:
    def __init__(self, config):
        self.session = requests.Session()
        self.config = config

    def get_games_list(self):
        url = f"{self.config['cloud_api_url']}/{self.config['endpoints']['base']}/{self.config['endpoints']['games']}"


        try:
            games_response = self.session.get(url, timeout=5, verify=False)
            games = json.loads(games_response.content)
            return games
        except:
            return []

    def get_game_by_id(self, id):
        url = f"{self.config['cloud_api_url']}/{self.config['endpoints']['base']}/{self.config['endpoints']['game']}/{id}"

        try:
            games_response = self.session.get(url, timeout=5)
            game = json.loads(games_response.content)
            return game

        except:
            return None

    def download_game(self, game, signal):
        url = f"{self.config['cloud_api_url']}/{self.config['endpoints']['download']}/{game['filePath']}"

        with io.BytesIO() as buffer:
            with self.session.get(url, stream=True, timeout=5) as file_content:
                total_length = file_content.headers.get('content-length')
                dl = 0

                for data in file_content.iter_content(chunk_size=4096):
                    dl += len(data)
                    buffer.write(data)
                    signal.emit(total_length, dl, game['id'])

                return buffer.getvalue()