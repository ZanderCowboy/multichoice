# 314 - Feature Flag Tutorial

- Gated the product-tour journey behind Remote Config `enable_tutorial` (default off)
- Welcome modal still shows for new users; Follow Tutorial and drawer Restart are hidden when disabled
- Mid-tour users with the flag off are silently marked complete