import requests  # type: ignore
import pandas as pd  # type: ignore
from datetime import datetime, timedelta
import time
import json
import sys
import traceback
import FinanceDataReader as fdr
import msg_generator
import matplotlib.pyplot as plt
# Upbit API Endpoints
CANDLE_URL = "https://api.upbit.com/v1/candles/days"

# Fetch historical price data
def fetch_data(symbol: str):
    try:
        one_year_ago = (datetime.now() - timedelta(days=365)).strftime("%Y-%m-%d")
        now = datetime.now().strftime("%Y-%m-%d")
        df = fdr.DataReader(symbol, one_year_ago, now)
        # df = fdr.DataReader(symbol, four_days_ago, five_days_ago)
        df.reset_index(inplace=True)
        df.rename(columns={'index': 'timestamp'}, inplace=True)
        return df
    except Exception as e:
        print(f"[Error in fetch_data] Symbol: {symbol}, Error: {e}")
        raise


# Calculate moving averages
def calculate_moving_averages(data):
    try:
        df = pd.DataFrame(data)
        df["Open"] = pd.to_numeric(df["Open"], errors="coerce")  # Ensure numeric
        df["ma_25"] = df["Open"].rolling(window=25).mean()
        df["ma_30"] = df["Open"].rolling(window=30).mean()
        return df
    except Exception as e:
        print(f"[Error in calculate_moving_averages] Error: {e}")
        raise


# Calculate Ichimoku Cloud components
def calculate_ichimoku(data):
    try:
        df = pd.DataFrame(data)
        df["High"] = pd.to_numeric(df["High"], errors="coerce")
        df["Low"] = pd.to_numeric(df["Low"], errors="coerce")
        df["conversion_line"] = (df['High'].rolling(window=9).max() +
                                 df["Low"].rolling(window=9).min()) / 2
        df["base_line"] = (df["High"].rolling(window=26).max() +
                           df["Low"].rolling(window=26).min()) / 2
        df["leading_span_a"] = ((df["conversion_line"] + df["base_line"]) /
                                2).shift(26)
        df["leading_span_b"] = ((df["High"].rolling(window=52).max() +
                                 df["Low"].rolling(window=52).min()) /
                                2).shift(26)
        return df
    except Exception as e:
        print(f"[Error in calculate_ichimoku] Error: {e}")
        raise


def draw_ichimoku_chart(data):
    try:
        plt.figure(figsize=(10, 6))
        plt.plot(data["conversion_line"])
        plt.plot(data["base_line"])
        plt.plot(data["leading_span_a"])
        plt.plot(data["leading_span_b"])
        plt.title("Ichimoku Cloud")
        plt.xlabel("Day")
        plt.ylabel("Price")
        plt.grid(True)
        plt.show()
    except Exception as e:
        print(f"[Error in draw_ichimoku_chart] Error: {e}")
        raise
# Retrieve all market codes
def get_all_market_code():
    try:
        return fdr.StockListing('S&P500')
    except Exception as e:
        print(f"[Error in get_all_market_code] Error: {e}")


# Strategy implementation
def strategy(market):
    try:
        data = fetch_data(market)
        ma_df = calculate_moving_averages(data)
        ichimoku_df = calculate_ichimoku(data)

        # Merge MA and Ichimoku data
        merged_df = pd.merge(ma_df, ichimoku_df, on='timestamp', suffixes=("", "_ichimoku"))

        today = merged_df.iloc[-1]
        yesterday = merged_df.iloc[-2]

        # Golden Cross condition
        golden_cross = (yesterday["ma_25"] <= yesterday["ma_30"] < today["ma_25"] > today["ma_30"])
        price_breakout = (yesterday["Open"] < yesterday["ma_30"]
                          and today["Open"] > today["ma_25"])

        # Ichimoku Cloud Buy condition
        buy_signal = (today["conversion_line"] > today["base_line"]
                      and today["leading_span_a"] > today["leading_span_b"]
                      and today["Open"] > today["leading_span_a"])

        # Ichimoku Cloud Sell condition
        sell_signal = (today["conversion_line"] < today["base_line"]
                       and today["leading_span_a"] < today["leading_span_b"]
                       and today["Open"] < today["leading_span_b"])

        signal = {
            'market': market,
            'golden_cross': golden_cross,
            'price_breakout': price_breakout,
            'buy_signal': buy_signal,
            'sell_signal': sell_signal,
        }
        return pd.DataFrame([signal])
    except Exception as e:
        print(f"[Error in strategy] Market: {market}, Error: {e}")
        traceback.print_exc()
        raise


# Send message to Slack
def send_msg(msg):
    try:
        url = "https://hooks.slack.com/services/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"
        title = (f"매수 신호 :zap: / " + datetime.now().strftime("%Y-%m-%d %H:%M"))
        slack_data = {
            "username": "서현이의 투자요정",
            "icon_emoji": ":satellite:",
            "attachments": [
                {
                    "color": "#9733EE",
                    "fields": [
                        {
                            "title": title,
                            "value": msg,
                            "short": "false",
                        }
                    ]
                }
            ]
        }
        headers = {'Content-Type': "application/json"}
        response = requests.post(url, data=json.dumps(slack_data), headers=headers)
        if response.status_code != 200:
            raise Exception(response.status_code, response.text)
    except Exception as e:
        print(f"[Error in send_msg] Error: {e}")
        raise

if __name__ == "__main__":
    try:
        temp_market_codes = get_all_market_code()
        market_codes = pd.DataFrame(temp_market_codes)['Symbol'].tolist()
        buy_list = pd.DataFrame(columns=["date", "market", "buy_signal", "golden_cross", "price_breakout"])
        failed_symbols = []  # To store failed symbols

        HTTP_REQUEST_DELAY = 0.02  # Adjustable delay for API requests
        
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
                if signal.iloc[0]['buy_signal'] or (signal.iloc[0]['golden_cross'] and signal.iloc[0]['price_breakout']):
                    print(f"{market_code} 매수 신호!")
                    buy_list = pd.concat([
                        buy_list,
                        pd.DataFrame([{
                            "date": datetime.now().strftime("%Y-%m-%d %H:%M"),
                            "market": market_code,
                            "buy_signal": signal.iloc[0]['buy_signal'],
                            "golden_cross": signal.iloc[0]['golden_cross'],
                            "price_breakout": signal.iloc[0]['price_breakout']
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
