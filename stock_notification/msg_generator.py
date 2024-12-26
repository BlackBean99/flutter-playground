def generate_buy_signal_msg(signals):
    """
    Generate a Slack-friendly message summarizing buy/sell signals in a table format.

    Parameters:
        signals (pd.DataFrame): A DataFrame containing market signals, including
                                'market', 'buy_signal', 'golden_cross', 'price_breakout', 'sell_signal'.

    Returns:
        str: A formatted message for Slack.
    """
    delimiter = "--------------------------------------------------------------------------------\n"
    
    # Sort signals for prioritization
    signals = signals.sort_values(
        by=['buy_signal', 'golden_cross', 'price_breakout'],
        ascending=[False, False, False]
    )
    
    # Create a table header
    msg = (
        f"{'Market':<10}{'Golden Cross':<15}{'Price Breakout':<20}{'Buy Signal':<15}\n"
        + delimiter
    )

    # Add each signal as a row in the table
    for _, signal in signals.iterrows():
        msg += (
            f"{signal['market']:<10}"  # Market column
            f"{'✅' if signal['golden_cross'] else '❌':<15}"  # Golden Cross column
            f"{'✅' if signal['price_breakout'] else '❌':<20}"  # Price Breakout column
            f"{'✅' if signal['buy_signal'] else '❌':<15}"  # Buy Signal column
            + "\n"
        )
    msg += delimiter
    return msg
