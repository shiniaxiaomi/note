最简单的布局:总共三行，每行都沾满所有的宽度

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="/css/bootstrap.min.css">
    <script src="/js/bootstrap.min.js"></script>

    <style>
        .col-sm{
            background-color: rgba(86,61,124,.15);
            border: 1px solid rgba(86,61,124,.2);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row">
          <div class="col-sm">
            One of three columns
          </div>
          <div class="col-sm">
            One of three columns
          </div>
          <div class="col-sm">
            One of three columns
          </div>
        </div>
      </div>
</body>
</html>
```

---

| auto <576px | sm ≥576px  | md ≥768px  | lg ≥992px  | xl ≥1200px |
| ----------- | ---------- | ---------- | ---------- | ---------- |
| None (auto) | 540px      | 720px      | 960px      | 1140px     |
| `.col-`     | `.col-sm-` | `.col-md-` | `.col-lg-` | `.col-xl-` |

每个栅格之间的间隔为30像素，即每个列的左右间隙都为15px

---

