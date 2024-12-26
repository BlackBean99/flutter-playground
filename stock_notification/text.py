# install requests
# python -m pip install requests
import requests  # type: ignore
import pandas as pd  # type: ignore
from datetime import datetime, timedelta
import time
import json
import sys
import traceback

# Upbit API Endpoints
CANDLE_URL = "https://api.upbit.com/v1/candles/days"
# Fetch historical price data
def fetch_data(market: str, count: int):
    params = {  
        'market': market,  
        'count': count,
        'to': datetime.now().strftime("%Y-%m-%d 09:00:00"),
        # 'converting_price_unit': 'KRW'
    }
    headers = {"accept": "application/json"}
    response = requests.get(CANDLE_URL, params=params, headers=headers)
    if response.status_code == 200:
        return pd.DataFrame(response.json())
    else:
        raise Exception(
            f"Error fetching data: {response.status_code}, {response.text}")




print(fetch_data('KRW-BTC',200))