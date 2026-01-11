# Nearest Customers API (Rails)

This Rails API accepts a text file containing customer data (one JSON object per line),
calculates distance using the Haversine formula, and returns customers within 100 km
of a fixed office location.

---

## Tech Stack

- Ruby: **3.3.8**
- Rails: **8.1.2**
- Database: **PostgreSQL**
- Testing: **RSpec**

---

## Problem Statement

- Input: `.txt` file
- Each line contains **one customer in JSON format**
- Use Haversine formula to calculate distance
- Return customers within **100 km**
- Output only `id` and `name`

Office location:
- Latitude: 19.0590317
- Longitude: 72.7553452

---

## API Endpoint

### POST `/api/v1/customers/nearest_customers`

#### Params

| Key  | Type | Required |
|-----|------|----------|
| file | File (.txt) | Yes |

---

## File Format Example (`customers.txt`)

```
{"id":1,"name":"User One","lat":19.0590317,"long":72.7553452}
{"id":2,"name":"User Two","lat":20.0590317,"long":72.7553452}
{"id":3,"name":"User Three","lat":19.0590317,"long":62.7553452}
```
---
## Responses

#### 400 – Missing file
```
{
  "error": "File missing"
}
```

#

#### 422 – Invalid file format
```
{
  "error": "Invalid file format"
}
```
#

#### 200 – Success
```
{
  "message": "nearest customers",
  "customers": [
    { "id": 1, "name": "User One" },
    { "id": 2, "name": "User Two" }
  ]
}
✔ Customers are sorted by id (ascending)
```
#

#### 200 – Invalid JSON lines present
```
{
  "message": "Invalid json at lines 2, 4",
  "customers": []
}

```
---

### Implementation Details

- Distance calculation uses the Haversine formula
- Core logic extracted into a service object
- Customers within 100 km are sorted by id (ascending)
- Controller remains thin and readable
- Invalid JSON lines are skipped and reported
- Specs written using RSpec
- API-only Rails application
- 
---
### Setup Instructions
```
bundle install
rails db:create
rails s
```
---


### Running Specs

```
bundle install
bundle exec rspec
```
---

### Notes

- This is an API-only implementation
- No database is used
- Input is processed line-by-line for efficiency

---


