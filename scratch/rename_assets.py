import os

base_path = r'c:\Users\BINKHALED\Desktop\jewelry_app-master\jewelry_app-master\assets\images'

mapping = {
    'اساور': 'bracelets',
    'اقراط': 'earrings',
    'خلخال': 'anklets',
    'خواتم': 'rings',
    'سلاسل': 'necklaces',
    'طقم كامل': 'sets',
    'غوايش': 'bangles',
    'كفوف': 'gloves'
}

for old_name, new_name in mapping.items():
    old_path = os.path.join(base_path, old_name)
    new_path = os.path.join(base_path, new_name)
    if os.path.exists(old_path):
        print(f"Renaming {old_name} to {new_name}")
        os.rename(old_path, new_path)
    else:
        print(f"Directory {old_name} not found")
