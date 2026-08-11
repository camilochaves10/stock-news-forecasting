# Stock Forecasting with Historical Prices and Market News

This project evaluates whether market news improves next-trading-day stock-price
forecasting beyond historical price and volume information.

It combines daily OHLCV data for seven technology companies with 4,439 cleaned
news articles. FinBERT transforms the news into financial-sentiment features,
which are evaluated alongside price, volume, machine-learning, and classical
time-series models.

## Start here

For a concise overview of the complete analysis, methodology, results, and final
recommendation, open:

### [`03_executive_report.ipynb`](notebooks/03_executive_report.ipynb)

This is the primary reviewer-facing notebook. It summarizes the work without
rerunning computationally expensive sentiment inference or model training.

The detailed supporting notebooks are:

- [`01_data_quality_eda.ipynb`](notebooks/01_data_quality_eda.ipynb)  
  Data validation, cleaning decisions, duplicate analysis, exploratory analysis,
  volatility, return distributions, and correlations.

- [`02_modeling_validation.ipynb`](notebooks/02_modeling_validation.ipynb)  
  Target construction, leakage-safe feature engineering, FinBERT sentiment,
  chronological validation, model training, ablation experiments, and error
  analysis.

## Research question

> Does market news provide incremental predictive value beyond historical price
> and volume information for next-trading-day stock forecasting?

The primary target is next-day close-to-close return:

\[
r_{i,t+1}
=
\frac{Close_{i,t+1}}{Close_{i,t}}
- 1
\]

Predicted returns are converted into next-day closing-price forecasts.

## Data

### Historical prices

- 1,687 OHLCV observations
- 241 trading sessions per ticker
- November 13, 2023 through October 28, 2024
- Tickers: AAPL, AMZN, GOOGL, META, MSFT, NVDA, and TSLA

Source: [price.csv](https://huy302.github.io/price.csv)

### Market news

- 4,440 raw articles
- 4,439 articles after exact deduplication
- Headlines, summaries, timestamps, and associated tickers
- FinBERT positive, neutral, and negative sentiment probabilities

Source: [news.csv](https://huy302.github.io/news.csv)

## Leakage controls

Financial forecasting is highly sensitive to temporal leakage. This project
uses the following safeguards:

- Chronological train, validation, and test periods
- No random train-test split
- All stocks from the same market date remain in the same split
- Rolling features use only information available through the prediction date
- News is assigned to the first trading session strictly after its publication
  date because the timestamp timezone is undocumented
- Validation performance guides model development
- The final test period is used for final assessment

## Models evaluated

- Random-walk baseline
- Global historical-mean return
- Ticker-specific historical-mean return
- Ridge regression
- Price-only XGBoost
- News-only XGBoost
- Price-plus-news XGBoost
- Damped Holt exponential smoothing
- ARIMA(1,0,0) with walk-forward evaluation
- Validation-weighted ensemble

## Principal findings

- News-only XGBoost produced the strongest validation-period performance.
- The news advantage did not persist on the final unseen test period.
- The ticker-specific historical-mean forecast achieved the lowest final test
  errors.
- Median and mean sentiment were the most informative news features.
- Article count and simply having news contributed little predictive value.
- News-only XGBoost improved test return MAE only for GOOGL.
- Days with news were substantially harder to predict than days without news.
- Apparent directional accuracy largely reflected the positive-return base rate
  rather than consistent discrimination between up and down days.

## Final test result

The ticker-specific historical-mean forecast was the strongest final benchmark:

| Metric | Result |
|---|---:|
| Price MAE | $3.184 |
| Price RMSE | $5.447 |
| Return MAE | 1.261% |
| Return RMSE | 2.214% |
| Directional accuracy | 58.01% |

The directional accuracy equals the positive-return base rate and should not be
interpreted as genuine market-direction skill.

## Conclusion

Market-news sentiment contains limited predictive information, but its
relationship with next-day returns is not stable across the validation and test
periods.

Within this one-year dataset, no machine-learning, time-series, sentiment, or
ensemble model consistently improves on a carefully constructed
ticker-specific historical-drift baseline.

For a production decision, historical drift should remain the champion model.
The news-only model should be treated as a challenger requiring evaluation over
longer histories and multiple market regimes.

## Repository structure

```text
stock-news-forecasting/
├── data/
│   ├── raw/
│   │   ├── price.csv
│   │   ├── news.csv
│   │   └── financial_feature_desc.md
│   └── processed/
│       └── news_with_finbert_sentiment.csv
├── notebooks/
│   ├── 01_data_quality_eda.ipynb
│   ├── 02_modeling_validation.ipynb
│   └── 03_executive_report.ipynb
├── outputs/
│   ├── figures/
│   └── metrics/
├── presentation/
├── src/
│   ├── __init__.py
│   ├── data.py
│   ├── features.py
│   ├── modeling.py
│   └── validation.py
├── tests/
│   ├── __init__.py
│   ├── test_data.py
│   └── test_features.py
├── .gitignore
├── Makefile
├── pyproject.toml
├── README.md
└── requirements.txt