# 🛒 E-Commerce User Funnel & Conversion Analysis

<div align="center">

![SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen?style=for-the-badge)

**Analysing 2.76 million customer events to find out why 99.17% of visitors never buy — and what to do about it.**

</div>

---

## 🧭 The Business Problem

Imagine you run an e-commerce store. Millions of people visit. They browse your products, they look around — and then they leave.

No add to cart. No purchase. Just... gone.

That's exactly what this dataset showed me.

This project started with a simple question:

> *"We have 1.4 million visitors. Why do we only have 11,719 buyers?"*

I set out to follow the data and answer that question — step by step, query by query.

---

## 📊 Dashboard Preview

![E-Commerce Funnel Dashboard](dashboard_screenshot.png)

*Interactive Power BI dashboard with slicers for Item ID and Event type.*

---

## 📖 The Story the Data Tells

### Chapter 1 — What We're Working With

The dataset contains **2,756,101 rows** of raw customer behaviour — every click, every cart add, every purchase — recorded across three event types.

```
view        → 2,664,312 events   (96.7% of all activity)
addtocart   →    69,332 events   ( 2.5% of all activity)
transaction →    22,457 events   ( 0.8% of all activity)
```

Right away, something stands out. Views dominate everything. The gap between browsing and buying is enormous — and that's the story we need to tell.

> 📌 **Data Quality Note:** 98.9% of `transactionid` values are NULL. This is expected — only completed purchases carry a transaction reference. Non-purchase events simply don't have one.

---

### Chapter 2 — Following the Funnel

I built a funnel CTE in SQL to track every unique visitor across all three stages. The results were stark:

| Funnel Stage | Unique Users | Conversion Rate |
|---|---|---|
| 👁️ **View** | 1,407,580 | 100% (baseline) |
| 🛒 **Add to Cart** | 38,722 | 2.75% |
| ✅ **Purchase** | 11,719 | **0.83%** |

**Read that again.** Out of every 1,000 people who visited and looked at a product:
- Only **27** added something to their cart
- Only **8** actually bought anything

That's not a traffic problem. The platform is reaching people. The problem is what happens *after* they arrive.

---

### Chapter 3 — Where Exactly Do They Leave?

There are two critical drop-off points in this funnel:

#### 🔴 Drop 1: View → Add to Cart ( −97.25% )

This is the biggest leak in the funnel. **1,368,858 people viewed products and left without a single cart action.**

Why does this happen?
- Product pages aren't compelling enough to trigger action
- No urgency signals — no stock warnings, no time-limited offers
- Pricing may not match user expectations
- Weak or missing social proof (reviews, ratings, sold counts)

#### 🟡 Drop 2: Add to Cart → Purchase ( −69.74% )

Of the 38,722 users who added something to their cart, **27,003 abandoned before checkout.**

Cart abandonment at this scale usually points to:
- Unexpected costs appearing at checkout (shipping, taxes)
- Friction from forced account creation
- Limited payment options
- Distrust at the payment stage

---

### Chapter 4 — What About the Products?

I ran a conversion rate query across all products with more than 50 views. The pattern was consistent and concerning:

- The **aggregate view-to-cart rate** across 2.75M+ item views is just **0.01** — meaning for every 100 views, fewer than 1 results in a cart add
- Many of the **most-viewed products** have near-zero cart additions
- High traffic ≠ high intent. The products are being seen. They're just not converting.

This tells me the problem isn't reach — it's the product experience itself.

---

### Chapter 5 — The 11,719 Who Did Buy

Let's not forget the people who *did* convert. There are **11,719 unique buyers** in this dataset.

That's a small but incredibly valuable group. They've already proven they trust the platform enough to pay. Retaining them, delighting them, and getting them to buy again is significantly cheaper than acquiring new customers — and this segment is currently being underserved.

---

## 💡 Recommendations

Based on the analysis, here's where I'd focus investment:

| Priority | Area | Action |
|---|---|---|
| 🔴 **HIGH** | Product Pages | A/B test CTA size, placement, and copy — make "Add to Cart" impossible to miss |
| 🔴 **HIGH** | Product Pages | Add urgency signals: low stock indicators, limited-time pricing |
| 🔴 **HIGH** | Cart Abandonment | Build a 3-touch email recovery sequence: 1 hour · 24 hours · 72 hours |
| 🔴 **HIGH** | Checkout | Enable guest checkout — remove forced registration friction |
| 🟡 **MED** | Product Catalogue | Audit top 100 high-view, low-cart products — fix descriptions and pricing |
| 🟡 **MED** | Retargeting | Serve personalised ads to cart abandoners using item-level data |
| 🔵 **LOW** | Analytics | Join events data to order/CRM tables for full revenue attribution |
| 🔵 **LOW** | Retention | Launch a loyalty programme targeting the 11.7K existing buyers |

> **The opportunity in one sentence:** Improving View-to-Cart conversion by just 2 percentage points would add ~28,000 additional cart users — more than tripling current cart volume without spending a single extra rupee on ads.

---

## 🧪 SQL Queries Breakdown

Every query in `funnel.sql` was written to answer a specific business question:

| Query Block | Business Question Answered |
|---|---|
| `Total Users` | How many unique people visited? |
| `NULL Analysis` | How complete is our transaction data? |
| `Event Distribution` | Where is user activity concentrated? |
| `User Per Event` | How many unique users reached each stage? |
| `Duplicate Check` | Are there data quality issues we need to flag? |
| `Funnel CTE` | What does the full View → Cart → Purchase journey look like? |
| `Which Products Fail` | Which specific products lose users between view and cart? |
| `User Behavior` | How active are individual users on the platform? |
| `Conversion Rate` | Which products have the worst view-to-cart conversion? |

The **Funnel CTE** is the centrepiece — it uses `MAX(CASE WHEN event = '...' THEN 1 ELSE 0 END)` per visitor to cleanly flag which stages each user reached, making the funnel calculation simple and accurate.

---

## 🗂️ Repository Structure

```
ecommerce-funnel-analysis/
│
├── 📄 funnel.sql                       # All SQL queries — fully commented
├── 🖼️  dashboard_screenshot.png         # Power BI dashboard preview
├── 📊 Ecommerce_Funnel_Analysis.pptx   # Full 10-slide project presentation
└── 📋 README.md                        # You are here
```

---

## 🔍 Dataset Reference

| Column | Type | Description |
|---|---|---|
| `visitorid` | INT | Unique user identifier |
| `itemid` | INT | Product identifier |
| `event` | VARCHAR | `view` / `addtocart` / `transaction` |
| `transactionid` | VARCHAR | Populated only on completed purchases (98.9% NULL) |

**Source:** [Retail Rocket E-Commerce Dataset — Kaggle](https://www.kaggle.com/datasets/retailrocket/ecommerce-dataset)

---

## 🛠️ Tools Used

| Tool | Purpose |
|---|---|
| **SQL Server (SSMS)** | Data exploration, cleaning, funnel logic, product analysis |
| **Power BI** | Interactive dashboard with Item ID and Event slicers |
| **PowerPoint** | Executive presentation of findings and recommendations |

---

## ▶️ How to Reproduce This Analysis

1. Download the dataset from [Kaggle](https://www.kaggle.com/datasets/retailrocket/ecommerce-dataset)
2. Create a database named `Events` in SQL Server Management Studio
3. Import the events CSV as a table named `events`
4. Open `funnel.sql` — each section is clearly labelled with a comment header
5. Run blocks individually top to bottom — the **Funnel CTE** and **Conversion Rate** queries at the bottom are the most important
6. Connect Power BI to the same database to reproduce the dashboard

---

## 📬 Let's Connect

I'm always open to discussing data, analytics, and interesting projects.

<div align="center">

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Pon%20Hariharan-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/pon-hariharan)
[![GitHub](https://img.shields.io/badge/GitHub-PonHariharan77-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/PonHariharan77)

</div>

---

<div align="center">

*Part of my personal data analytics portfolio — turning raw data into decisions.*

⭐ If this project was useful or interesting, feel free to star the repo!

</div>
