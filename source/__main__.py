#!/usr/bin/env python3

from os import path
import json
import logging.config
import requests
import sys
import yaml

# Read logging config from file
with open("config.yaml", "r") as f:
    config = yaml.load(f, Loader=yaml.FullLoader)

# Apply logging handlers to execution
logging.config.dictConfig(config)
logger = logging.getLogger(__name__)


class InteractAPI:
    """
    _summary_
    """

    def __init__(self, url, file_name):
        self.url = url
        logger.debug(f"variable (url) set: {url}")

        self.file_name = file_name
        logger.debug(f"variable (file_name) set: {file_name}")

    def query_api_no_auth(self):
        """
        Query API.

        Returns:
            str: Json output.
        """

        headers = {"Content-Type": "application./json"}

        response = requests.get(url, headers=headers)

        if response.status_code == 200:
            data = response.text
            logger.info("sucessfully reached remote api")
            logger.debug(f"variable (data) set: {data}")
            return data
        else:
            logger.error(
                f"{response.status_code}, unable to properly download api data"
            )
            sys.exit(0)

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

        logger.debug(f"variable (beer_list) set: {beer_list}")
        logger.info("detected locally cached data; won't pull data from api")

        return beer_list


if __name__ == "__main__":
    """
    _summary_
    """

    url = "https://api.punkapi.com/v2/beers"
    file_name = "data/api-downloaded-data.json"

    api_data_object = InteractAPI(url, file_name)

    # If file already exists and with data, don't query the API
    if not path.isfile(file_name):
        logger.info(f"{file_name} not present; creating file")
        with open(file_name, "w") as file:
            pass

    if path.getsize(file_name) == 0:
        logger.info(f"{file_name} empty file detected; downloading data")
        json_data = api_data_object.query_api_no_auth()
        api_data_object.cache_data(json_data)

    locally_cached_data = api_data_object.read_cached_data()
