# Hero Background Image Instructions

## 📸 Add Your Background Image

Your website now uses a background image for the hero section instead of the pink gradient!

### Step 1: Prepare Your Image

**Recommended specifications:**
- **File name:** background-1.jpg (or .png)
- **Dimensions:** 1920px × 1080px (or higher)
- **Format:** JPG or PNG
- **File size:** Under 500KB (compress if needed)
- **Content:** Beauty products, elegant composition, or related imagery

### Step 2: Place the Image

Put your background image in this location:
```
images/background-1.jpg
```

Full path structure:
```
your-website/
├── index.html
├── styles.css
├── script.js
└── images/
    ├── background-1.jpg  ← ADD YOUR IMAGE HERE
    ├── vitamins-supplements.jpg
    ├── skin-whitening.jpg
    └── gallery/
        └── (your 12 product images)
```

### Step 3: That's It!

Once you add `background-1.jpg` to the images folder, it will automatically display as the hero background!

---

## 🎨 Current Hero Section Setup

The hero section now has:
- ✅ Background image (images/background-1.jpg)
- ✅ Semi-transparent white overlay (30% opacity)
- ✅ White text on top
- ✅ "Explore Products" button
- ✅ Fully responsive

---

## 💡 Image Tips

### Good Background Images:
- Products arranged beautifully
- Soft, diffused lighting
- Not too busy or cluttered
- Light or neutral colors work best
- Professional product photography

### What to Avoid:
- Very dark images (text won't show well)
- Too much detail/busy patterns
- Low resolution images
- Images with text already on them

---

## 🔧 Customization Options

### Change Overlay Opacity

If you want to adjust the white overlay, edit `styles.css` around line 145:

```css
.hero-overlay {
    background: rgba(255, 255, 255, 0.3);  /* Change 0.3 to adjust */
}
```

Values:
- `0.1` = Very light overlay (10%)
- `0.3` = Current (30%)
- `0.5` = Medium overlay (50%)
- `0.7` = Heavy overlay (70%)

### Change Overlay Color

For a darker overlay:
```css
.hero-overlay {
    background: rgba(0, 0, 0, 0.3);  /* Black overlay */
}
```

For a colored overlay:
```css
.hero-overlay {
    background: rgba(244, 194, 194, 0.3);  /* Soft rose overlay */
}
```

---

## 📱 Responsive Behavior

The background image automatically adjusts on different devices:
- **Desktop:** Full image visible, centered
- **Tablet:** Scaled and centered
- **Mobile:** Scales to fit screen width

---

## 🎯 Alternative: Use Gradient + Image

If you want both gradient and image:

```css
.hero {
    background-image: 
        linear-gradient(135deg, rgba(244, 194, 194, 0.5), rgba(139, 123, 139, 0.5)),
        url('../images/background-1.jpg');
    background-size: cover;
    background-position: center;
}
```

---

## ✅ Current vs Previous

**Previous:** Pink to purple gradient  
**Now:** Background image with white overlay  

**Result:** More professional, customizable, and shows your products!

---

**Add your background-1.jpg image to the images/ folder and refresh to see it!** 🎨
