import requests # type: ignore
import pandas as pd # type: ignore
from datetime import datetime, timedelta
import time
import json
import sys
import slack_sdk
import msg_generator
import traceback
# Upbit API Endpoints
CANDLE_URL = "https://api.upbit.com/v1/candles/days"

# print(response.text)

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


# Calculate moving averages
def calculate_moving_averages(data):
    df = pd.DataFrame(data)
    df["timestamp"] = pd.to_datetime(df["candle_date_time_kst"])
    df = df.sort_values(by="timestamp").reset_index(drop=True)

    df["ma_25"] = df["trade_price"].rolling(window=25).mean()
    df["ma_30"] = df["trade_price"].rolling(window=30).mean()
    return df


# Calculate Ichimoku Cloud components
def calculate_ichimoku(data):
    df = pd.DataFrame(data)
    df["timestamp"] = pd.to_datetime(df["candle_date_time_kst"])
    df = df.sort_values(by="timestamp").reset_index(drop=True)

    df["conversion_line"] = (df["high_price"].rolling(window=9).max() +
                             df["low_price"].rolling(window=9).min()) / 2
    df["base_line"] = (df["high_price"].rolling(window=26).max() +
                       df["low_price"].rolling(window=26).min()) / 2
    df["leading_span_a"] = ((df["conversion_line"] + df["base_line"]) /
                            2).shift(26)
    df["leading_span_b"] = ((df["high_price"].rolling(window=52).max() +
                             df["low_price"].rolling(window=52).min()) /
                            2).shift(26)
    return df


def get_all_market_code():
    url = "https://api.upbit.com/v1/market/all"
    headers = {"accept": "application/json"}
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        return response.json()
    else:
        raise Exception(
            f"Error fetching data: {response.status_code}, {response.text}")

# Strategy implementation
def strategy(market):
    date_period = 200
    # Fetch the last date days of data to calculate MA and Ichimoku
    data = fetch_data(market, date_period)
    ma_df = calculate_moving_averages(data)
    ichimoku_df = calculate_ichimoku(data)

    # Merge MA and Ichimoku data
    merged_df = pd.merge(ma_df,
                         ichimoku_df,
                         on="timestamp",
                         suffixes=("", "_ichimoku"))

    today = merged_df[-1]
    yesterday = merged_df[-2]

    # Golden Cross condition
    golden_cross = (yesterday["ma_25"] <= yesterday["ma_30"] < today["ma_25"] >
                    today["ma_30"])
    price_breakout = (yesterday["opening_price"] < yesterday["ma_30"]
                    and today["opening_price"] > today["ma_25"])

    # Ichimoku Cloud Buy condition
    buy_signal = (today["conversion_line"] > today["base_line"]
                and today["leading_span_a"] > today["leading_span_b"]
                and today["trade_price"] > today["leading_span_a"])

    signal = {'market': market, 
              'golden_cross': golden_cross,
                'price_breakout': price_breakout,
                'buy_signal': buy_signal,
            }
    return signal

def send_msg(msg):
    url = "https://hooks.slack.com/services/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"
    message = ("Train 완료!!!\n" + msg) 
    title = (f"매수 신호 :zap: / " + datetime.now().strftime("%Y-%m-%d %H:%M")) # 타이틀 입력
    slack_data = {
        "username": "서현이의 투자요정", # 보내는 사람 이름
        "icon_emoji": ":satellite:",
        #"channel" : "#somerandomcahnnel",
        "attachments": [
            {
                "color": "#9733EE",
                "fields": [
                    {
                        "title": title,
                        "value": message,
                        "short": "false",
                    }
                ]
            }
        ]
    }
    byte_length = str(sys.getsizeof(slack_data))
    headers = {'Content-Type': "application/json", 'Content-Length': byte_length}
    response = requests.post(url, data=json.dumps(slack_data), headers=headers)
    if response.status_code != 200:
        raise Exception(response.status_code, response.text)
    
# Example usage
if __name__ == "__main__":
    try:
        temp_market_codes = get_all_market_code()
        market_codes = pd.DataFrame(temp_market_codes)['market'].tolist()
        buy_list = pd.DataFrame(columns=["date", "market", "buy_signal", "golden_cross", "price_breakout"])
        failed_symbols = []  # To store failed symbols

        HTTP_REQUEST_DELAY = 100  # Adjustable delay for API requests
        for market_code in market_codes:
            try:
                print(f"Processing {market_code}...")
                signal = strategy(market_code)
                time.sleep(HTTP_REQUEST_DELAY)

                # Print the individual signal components for debugging
                print(f"Debug [{market_code}] - Signals:")
                print(f"  Golden Cross: {signal['golden_cross']}")
                print(f"  Price Breakout: {signal['price_breakout']}")
                print(f"  Buy Signal: {signal['buy_signal']}")

                # Check for buy conditions
                if signal['buy_signal']: 
                    if (signal['golden_cross'] and signal['price_breakout']):
                        print(f"{market_code} 매수 신호!")
                        buy_list = pd.concat([
                            buy_list,
                            pd.DataFrame([{
                                "date": datetime.now().strftime("%Y-%m-%d %H:%M"),
                                "market": market_code,
                                "buy_signal": signal['buy_signal'],
                                "golden_cross": signal['golden_cross'],
                                "price_breakout": signal['price_breakout']
                            }])
                        ], ignore_index=True)
                else:
                    print(f"{market_code} did not meet buy conditions.")

            except Exception as e:
                # Log the failed symbol and the error
                print(f"[Error] Failed to process {market_code}. Error: {e}")
                failed_symbols.append({"symbol": market_code, "error": str(e)})

        # Save successful buy signals to CSV
        if not buy_list.empty:
            buy_list.to_csv("buy_list.csv", index=False)
            print(f"Buy list saved. {len(buy_list)} items.")
        else:
            print("No buy signals generated.")

        # Save failed symbols to CSV
        if failed_symbols:
            failed_df = pd.DataFrame(failed_symbols)
            failed_df.to_csv("failed_symbols.csv", index=False)
            print(f"Failed symbols saved. {len(failed_symbols)} items.")

        # Send a message with the results
        send_msg(msg_generator.generate_buy_signal_msg(buy_list))
    except Exception as e:
        print(f"[Main Error] Error: {e}")
        traceback.print_exc()