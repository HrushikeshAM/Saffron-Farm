# AxiomGreen - Game Asset Library & Directory Catalog

This directory contains the production-ready game assets extracted, separated, trimmed, and standardized from the original generation files.

An interactive browser viewer is available at [`asset_viewer.html`](file:///c:/Users/Hrushikesh/Downloads/SGProper/asset_viewer.html). Open it in any browser to test animations, inspect transparent frames, and copy asset paths.

---

## Directory Structure Overview

```
SGProper/
├── asset_viewer.html                 # Interactive live visualizer and animation player
├── manifest.json                     # JSON metadata manifest for game engines and scripts
├── ASSET_CATALOG.md                  # Complete asset index & documentation
├── process_assets.py                 # Automated Python pipeline script
├── raw_originals/                    # Pristine original Firefly generation source files
│   ├── 01_Main_Menu_Background_...jpg
│   ├── Firefly.png
│   └── Firefly (1).png ... (14).png
└── assets/                           # Production-Ready Assets
    ├── backgrounds/                  # Environment and background scenes
    ├── cultivation_trays/            # 6-Stage growth lifecycle trays (pixel-aligned)
    ├── equipment/                    # Tanks, baskets, and packaged products
    ├── grow_lights/                  # 4 lighting intensity modes + spritesheet
    ├── dryers/                       # 6 dehydrator thermal states + spritesheet
    ├── watering_can/                 # 5-frame watering animation + spritesheet
    ├── icons/                        # 10 gameplay icons + decorative banner
    └── ui_buttons/                   # 12 circular/square game UI buttons
```

---

## Asset Index by Category

### 1. Backgrounds (`assets/backgrounds/`)
| Filename | Source | Dimensions | Description |
| :--- | :--- | :--- | :--- |
| `background_greenhouse_interior.jpg` | `01_Main_Menu_Background...jpg` | 2752×1536 | Full 2K greenhouse vertical-farming interior for title screen or main gameplay view. |

---

### 2. Cultivation Trays (`assets/cultivation_trays/`)
> **Engine Alignment Note:** All 6 stages share identical bounding-box registration (`2410×1490 px`). When transitioning between stages, the tray remains locked in 2D position with zero jitter while plants sprout and bloom.

| Filename | Source | Lifecycle Stage | Description |
| :--- | :--- | :--- | :--- |
| `tray_stage_01_soil.png` | `Firefly (9).png` | Stage 1 | Empty potting soil bed prepared for planting. |
| `tray_stage_02_bulbs.png` | `Firefly (7).png` | Stage 2 | Saffron corms / bulbs planted in soil cells. |
| `tray_stage_03_sprouting.png` | `Firefly (6).png` | Stage 3 | Early sprouts and germinated green shoots. |
| `tray_stage_04_growing.png` | `Firefly (5).png` | Stage 4 | Active vegetative growth of young saffron leaves. |
| `tray_stage_05_vegetative.png` | `Firefly (4).png` | Stage 5 | Full mature dense green saffron foliage. |
| `tray_stage_06_bloom.png` | `Firefly (2).png` | Stage 6 | Full flowering saffron blossoms with red stigmas. |

---

### 3. Equipment & Items (`assets/equipment/`)
| Filename | Source | Dimensions | Description |
| :--- | :--- | :--- | :--- |
| `water_tank_storage.png` | `Firefly.png` | 1078×1282 | Hydroponic water reservoir with ladder, liquid level tube, and valve. |
| `saffron_harvest_basket.png` | `Firefly (8).png` | 1842×1318 | Woven wicker basket filled with harvested purple saffron flowers. |
| `saffron_packaged_product.png` | `Firefly (1).png` | 1870×1310 | Glass display jar filled with dried red saffron + luxury gift box. |

---

### 4. Grow Lights (`assets/grow_lights/`)
| Filename | Source | Dimensions | State / Mode |
| :--- | :--- | :--- | :--- |
| `grow_light_stage_01_dim.png` | `Firefly (10).png` | 643×456 | Low / dimmed purple LED grow light. |
| `grow_light_stage_02_medium.png` | `Firefly (10).png` | 645×455 | Medium illumination intensity. |
| `grow_light_stage_03_bright_glow.png` | `Firefly (10).png` | 644×456 | Maximum bloom flare / luminous light intensity. |
| `grow_light_stage_04_standard.png` | `Firefly (10).png` | 643×458 | Standard active full-spectrum purple LED panel. |
| `grow_light_spritesheet.png` | Generated | 2600×460 | 4-frame unified horizontal spritesheet. |

---

### 5. Saffron Dehydrator Dryers (`assets/dryers/`)
*Note: Background watermarks and text annotations from the original generation have been removed.*

| Filename | Source | Dimensions | Machine State |
| :--- | :--- | :--- | :--- |
| `dryer_state_01_off_empty.png` | `Firefly (11).png` | 627×541 | Unit powered off with empty wire racks. |
| `dryer_state_02_preheating.png` | `Firefly (11).png` | 627×541 | Preheating mode with warm interior illumination. |
| `dryer_state_03_drying_low.png` | `Firefly (11).png` | 626×541 | Active drying mode with loaded saffron filaments. |
| `dryer_state_04_drying_high.png` | `Firefly (11).png` | 627×541 | Peak heating mode with glowing thermal heat vents. |
| `dryer_state_05_completed.png` | `Firefly (11).png` | 622×543 | Cycle complete; digital timer reads `00:00:00`. |
| `dryer_state_06_cooldown_idle.png` | `Firefly (11).png` | 621×543 | Cooldown / idle state ready for unloading. |
| `dryer_spritesheet.png` | Generated | 3780×545 | 6-state unified horizontal spritesheet. |

---

### 6. Watering Can (`assets/watering_can/`)
*Extracted via 2D connected-component segmentation to isolate droplets and streams.*

| Filename | Source | Dimensions | Animation Keyframe |
| :--- | :--- | :--- | :--- |
| `watering_can_anim_01_idle.png` | `Firefly (12).png` | 531×407 | Frame 1: Resting on surface. |
| `watering_can_anim_02_tilt.png` | `Firefly (12).png` | 500×446 | Frame 2: Tilting downward. |
| `watering_can_anim_03_spray.png` | `Firefly (12).png` | 558×742 | Frame 3: Pouring water spray with individual droplets. |
| `watering_can_anim_04_stream.png` | `Firefly (12).png` | 578×764 | Frame 4: Pouring heavy continuous stream with ground ripples. |
| `watering_can_anim_05_drip.png` | `Firefly (12).png` | 509×473 | Frame 5: Tilting back upright with final drip at spout. |
| `watering_can_spritesheet.png` | Generated | 2900×770 | 5-frame horizontal spritesheet. |

---

### 7. Gameplay Icons (`assets/icons/`)
| Filename | Source | Dimensions | Usage |
| :--- | :--- | :--- | :--- |
| `banner_axiomgreen_title.png` | `Firefly (13).png` | 1542×153 | Main title / category header banner. |
| `icon_currency_gold_coin.png` | `Firefly (13).png` | 409×423 | Gold coin currency ("VR" emblem). |
| `icon_resource_water_drop.png` | `Firefly (13).png` | 340×424 | Water resource counter. |
| `icon_energy_light_bulb.png` | `Firefly (13).png` | 301×437 | Electricity, power, or lighting resource. |
| `icon_timer_stopwatch.png` | `Firefly (13).png` | 385×447 | Timers, cooldowns, and crop speed-up. |
| `icon_rating_star.png` | `Firefly (13).png` | 381×398 | Score, ratings, and quest stars. |
| `icon_level_progress_badge.png` | `Firefly (13).png` | 528×255 | Player level badge ("LV" banner). |
| `icon_saffron_corm_bulb.png` | `Firefly (13).png` | 328×422 | Planting seed / corm item. |
| `icon_saffron_flower.png` | `Firefly (13).png` | 364×418 | Harvested saffron flower resource. |
| `icon_delivery_shipping_box.png` | `Firefly (13).png` | 398×404 | Delivery orders and logistics export. |
| `icon_status_checkmark.png` | `Firefly (13).png` | 395×365 | Quest completion / success confirmation. |

---

### 8. Game UI Buttons (`assets/ui_buttons/`)
| Filename | Source | Dimensions | Intended Button Action |
| :--- | :--- | :--- | :--- |
| `btn_tools_crafting.png` | `Firefly (14).png` | 224×227 | Open Tools / Build / Equipment menu. |
| `btn_market_shop.png` | `Firefly (14).png` | 225×227 | Open Marketplace / Seed Store. |
| `btn_inventory_backpack.png` | `Firefly (14).png` | 225×227 | Open Player Inventory / Bag. |
| `btn_quests_tasks.png` | `Firefly (14).png` | 224×227 | Open Missions, Tasks, and Quest Log. |
| `btn_settings_options.png` | `Firefly (14).png` | 226×230 | Open Game Settings / Options. |
| `btn_menu_hamburger.png` | `Firefly (14).png` | 227×229 | Open Main Pause / Navigation Menu. |
| `btn_navigation_left.png` | `Firefly (14).png` | 227×229 | Previous Page / Navigate Left. |
| `btn_navigation_right.png` | `Firefly (14).png` | 226×229 | Next Page / Navigate Right. |
| `btn_action_cancel_close.png` | `Firefly (14).png` | 227×230 | Close Window / Cancel Action (Red X). |
| `btn_action_add_plus.png` | `Firefly (14).png` | 228×229 | Add / Buy / Upgrade slot (Golden Plus). |
| `btn_status_locked.png` | `Firefly (14).png` | 228×229 | Locked Feature / Unlock Requirement (Padlock). |
| `btn_greenhouse_facility.png` | `Firefly (14).png` | 227×229 | Return to Greenhouse / Farm HQ. |
