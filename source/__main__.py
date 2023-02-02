#!/usr/bin/env python3

from os import path
import sys
import json
import logging
import requests

logging.basicConfig(
    filename="script_logging.log",
    level=logging.DEBUG,
    format="%(asctime)s - %(message)s",
    datefmt="%Y-%M-%d %H:%M:%S",
)


class InteractAPI:
    """
    _summary_
    """

    def __init__(self, url, file_name):
        self.url = url
        logging.info(f"url: {url}")

        self.file_name = file_name
        logging.info(f"file_name: {file_name}")

    def query_api(self):
        """
        Query API.

        Returns:
            str: Json output.
        """

        r = requests.get(url)
        data = r.text
        logging.info(f"data: {data}")

        return data

    def cache_data(self, json_data):
        """
        Save json output into local file.

        Args:
            json_data (str): Json output from api call.
        """

        with open(self.file_name, "w") as json_file:
            json_file.write(json_data)

    def read_cached_data(self):
        """
        Read data saved in file.

        Returns:
            list: Contains data filtered from original json api response.
        """

        beer_list = []

        with open(self.file_name) as json_file:
            data = json.load(json_file)

            for item in data:
                name = item["name"]
                first_brewed = item["first_brewed"]
                abv = item["abv"]

                beer = {"name": name, "first_brewed": first_brewed, "abv": abv}

                beer_list.append(beer)

        logging.info(f"beer_list: {beer_list}")

        return beer_list


if __name__ == "__main__":
    """
    _summary_
    """

    url = "https://api.punkapi.com/v2/beers"
    file_name = "json-downloaded-data.json"

    api_data_object = InteractAPI(url, file_name)

    # If file already exists and with data, don't query the API
    if not path.isfile(file_name):
        if path.getsize(file_name) != 0:
            json_data = api_data_object.query_api()
            api_data_object.cache_data(json_data)

    filtered_data = api_data_object.read_cached_data()

    # Make the response more human readable
    print(json.dumps(filtered_data, indent=4))
