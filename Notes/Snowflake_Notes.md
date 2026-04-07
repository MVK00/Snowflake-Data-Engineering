# Snowflake Notes

---

## What is Snowflake?

Snowflake is a cloud-based data warehousing platform that provides an end-to-end solution for data storage, processing, and analytics.

It eliminates the need for multiple tools (data lakes, warehouses, ETL tools) by providing everything under a single platform.

### Key Capabilities:
- Supports structured, semi-structured, and unstructured data  
- Centralized storage (single source of truth)  
- Multiple users can access the same data simultaneously  
- Pay-as-you-use pricing model  
- Real-time data sharing across teams  

---

## Architecture Overview

Snowflake follows a **Multi-Cluster Shared Data Architecture**.

It separates **Storage** and **Compute**, allowing independent scaling and high performance.

---

## Architecture Layers

### 1. Cloud Services Layer (Brain)

Responsible for managing the system:

- Authentication & Access Control  
- Security & Encryption  
- Metadata Management  
- Query Parsing & Optimization  
- Infrastructure Management  
- Result Caching  
- High Availability  

---

### 2. Compute Layer (Virtual Warehouses)

- Executes queries  
- Independent compute clusters  
- Can scale up or down based on workload  

#### Key Points:
- Multiple warehouses can run simultaneously  
- No resource contention  
- Uses cloud VMs (AWS / Azure / GCP)

---

### 3. Storage Layer

- Stores data in cloud storage (S3 / ADLS / GCS)  
- Data is not directly accessible  
- Access only through SQL queries  

#### Features:
- Automatic compression  
- Encryption  
- Micro-partitioning  

---

## Micro-Partitioning

- Data is divided into small partitions  
- Immutable (cannot be modified)  
- Improves query performance  
- Helps in data recovery  

---

## Traditional vs Snowflake Architecture

### Shared-Disk
- Multiple nodes share same storage  
- Queries can block each other  

### Shared-Nothing
- Each node has its own storage  
- Data is distributed across nodes  
- Queries must scan all nodes  

### Snowflake
- Shared storage + independent compute  
- No query blocking  
- Better scalability  

---

## Cost Model

Snowflake uses a **credit-based pricing model**:

- Compute cost → based on warehouse usage  
- Storage cost → based on data stored  

  Pay only for what you use  

---

## Views

### Standard View
- Executes query every time  
- Performs full table scan  

### Materialized View
- Stores precomputed results  
- Improves performance for aggregations  
- Uses cached data  

---

## Stages

- Used for loading and unloading data  
- Acts as an intermediate storage location  

---

## File Formats

- Define structure of data files  
- Used during data loading and unloading  

---

## Data Loading

- Data is loaded using:
  - Stages  
  - File formats  

---

## Streams (Change Data Capture)

Streams track changes in tables:

- Inserts  
- Updates  
- Deletes  

### Purpose:
- Enables incremental data processing  
- Avoids full data reloads  

---

## Tasks (Automation)

Tasks are used to automate SQL queries.

### Use Cases:
- ETL jobs  
- Data transformation  
- Scheduled data loading  

### Types:
- Cron-based → runs at specific time  
- Interval-based → runs periodically  

---

## Time Travel

Used to recover historical data.

### Handles:
- Accidental deletes  
- Table drops  
- Data changes  

### Retention:
- Up to 90 days (based on edition)

---

## Fail-safe

- Provides additional recovery after Time Travel  

### Key Points:
- Default: 7 days  
- Only for permanent tables  
- Used for disaster recovery  

---

## Cloning

- Creates instant copies of data  

### Use Cases:
- Production → Testing  
- Backup and experimentation  

### Key Feature:
- Zero-copy cloning (no extra storage initially)

---

## Key Takeaways

- Separation of compute and storage  
- Independent scaling of workloads  
- No query contention  
- Efficient cost management  
- Supports modern data engineering workflows  

---
