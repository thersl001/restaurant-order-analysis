#  🍽️ Restaurant Order Analysis using SQL 

## 📌 Project Overview
This project uses SQL to analyze food order data from a restaurant.
It utilizes two datasets: `menu_items` and `order_details`, and creates a joined table for analysis.

---

## 📊 Key Analyses Performed
- Total food items and category-wise distribution
- Most and least expensive items overall and within italian category
- Duration between first and last order
- Least and most sold food item
- Orders with high item counts (e.g., >12 items)
- Top 5 highest bills by customer

---

## 📂 Project Structure

```
Restaurant-Order-Analysis/
│
├── scripts.sql/
│   ├── ddl.sql                                # Script for table creation and data insertion
│   ├── analysis.sql                           # Script for data analysis
│
├── README.md                                  # Project overview
│
└── findings.pdf                               # Key findings from analysis
