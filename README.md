# The Great Analyzer

A Victoria II save game analyzer. Based on old [Nashetovich's code](http://oldforum.paradoxplaza.com/forum/showthread.php?715468)
(the Victoria 2 Savegame Economy Analyzer), modernised to run on current Java, and extended into a full record of
your campaign: economy, population, provinces, armed forces, wars and battles, and their history over time,
presented in a Victorian ledger style. Mods such as GFM are supported (names, government flags, formable nations).

![Nations](docs/screenshots/nations.png)

## What it shows

| Tab / window | Contents |
|---|---|
| **Nations** | The original economy ledger (GDP, GDP per capita, unemployment, wages) plus POP size, provinces, regiments, men, ships and army quality. Double-click for the nation window. |
| **Goods** | The original market table plus the people producing each good worldwide (RGO workers, factory workers, artisans) and the leading producer with its share of world output. |
| **Provinces** | Every province: owner, controller (occupied provinces highlighted), POP size, dominant culture and religion, RGO good and workers, factory workers, artisans, GDP, GDP per capita, literacy, militancy, infrastructure. |
| **Armed forces** | Regiments, men, strength, composition (infantry, cavalry, support, special), organisation, experience, readiness, quality and land power; ships, capital ships, naval experience and naval power; generals and admirals. Select nations and compare them side by side. |
| **Wars** | Every active and concluded war: dates, duration, sides, war goals, how countries joined and left, land casualties and naval losses per side and per nation, the inferred outcome and the rule used to infer it, and every battle with commanders, forces engaged, losses and victor. Double-click a battle for its record. |
| **Battle window** | One battle: the result and which war side it favoured, both armies or fleets with their nation, commander (and his traits, if still serving), forces by arm and losses, comparison charts, the field, other battles fought there in the war, and previous/next battle. |
| **Chronicle** | History across many saves: price of each good, each nation's share of world production of each good (per save, so per year with yearly autosaves), producer POP counts over time, POP size, occupations, armies and GDP per nation. |
| **Nation window** | Economy pies, population (occupations, cultures, religions, largest provinces), provinces, production with world shares and producers, armies and fleets, wars with results (including those fought under a former tag, e.g. Russia before the Slavic Union), and history charts. |
| **Good window** | Market pies, producers by nation, price history against base price, market control history, producer history, world output. |
| **Province window** | Present state (POP table, occupations, cultures, religions, RGO, factories, artisans, GDP, GDP per capita), owner and controller history, POP size and occupation history, GDP history, and battles fought there. |

`Help > How figures are reckoned` in the app documents every definition.

| | |
|---|---|
| ![Wars](docs/screenshots/wars.png) | ![Armed forces](docs/screenshots/armed_forces.png) |
| ![Market control](docs/screenshots/chronicle_market_control.png) | ![Prices](docs/screenshots/chronicle_prices.png) |
| ![Province history](docs/screenshots/province_history.png) | ![Nation history](docs/screenshots/nation_history.png) |
| ![Good history](docs/screenshots/good_history.png) | ![Provinces](docs/screenshots/provinces.png) |

The screenshots use the synthetic test campaign from `tools/make_synthetic_campaign.py`, not a real game.

## Usage

1. On Windows, unzip `The-Great-Analyzer-windows-x64.zip` anywhere you can write to (Desktop, Documents, a games
   folder) and double-click **`The Great Analyzer.exe`**. Java is bundled; nothing needs installing. Keep the `app` and `runtime`
   folders next to the exe. Windows may warn that the publisher is unknown, because the exe is not code-signed:
   choose "More info" and "Run anyway".
   Otherwise download [a release](https://github.com/aekrylov/vic2_economy_analyzer/releases) or build it yourself (below).
2. Set **Save game**, and **Game path** to your Victoria II installation (and **Mod path** if you play a mod).
   The game path supplies country names, goods, factory types, unit statistics, technologies and inventions;
   without it, army quality and power cannot be computed and are shown as "n/a".
3. Press **Load save**.
4. For history, open the **Chronicle** tab and choose **Compile from folder...** (or **from saves...**) with the saves
   of one campaign, typically the yearly autosaves. Use **Save chronicle...** so the saves need not be read again;
   **Add loaded save** appends the save currently loaded. Watchers (menu `Watchers`) now also keep a chronicle
   next to their history file, fed with every new save, which **Open chronicle** shows.

Double-click a table row, or click a chart slice or bar, to open the detailed window. Hover anywhere over a line
chart to read every series at the nearest date.

### Compiling a chronicle from the command line

For a long campaign it can be convenient to compile overnight:

```
gradle chronicle --args="--game 'C:/Games/Victoria 2' --out campaign.v2chronicle 'C:/Users/me/Documents/Paradox Interactive/Victoria II/save games'"
```

Add `--add` to append to an existing chronicle and `--mod DIR` for mods.

## How a few figures are inferred

- **War outcomes.** The game does not record peace terms. A concluded war is judged, in order, by war goals flagged
  fulfilled; the annexation of a war leader (its main heir being on the other side); the war leader now holding the
  state targeted by the war goal; provinces whose control changed on the peace date and now belong to one side;
  goals recorded but none met suggest a white peace; otherwise the outcome is "Undetermined". The rule applied is
  shown beside each outcome.
- **Battle sides.** A battle's attacker is the army that attacked into the province, not necessarily the side that
  declared the war; The Great Analyzer resolves each army to its war side before tallying casualties.
- **Formable nations.** Wars and battles are recorded under the tag a nation had at the time. A vanished tag is
  treated as a nation's predecessor when it had the same capital and culture, when nearly all of its cores are now
  the nation's, or when its generals now serve the nation, and it never fought against the nation.
- **Province GDP.** The nation's GDP (the original analyzer's figure) apportioned by each province's productive
  income: RGO income, its share of factory income by resident employees, and artisan output.
- **Control history** is known only at the dates of the saves in the chronicle.

## How to build

Requires JDK 17 or newer (tested with JDK 21).

- `./gradlew run` runs the app.
- `./gradlew test` runs the parser and chronicle tests on the synthetic fixtures in `src/test/resources/fixture`.
- `./gradlew jpackage` makes a runtime image in `build/dist` (no JVM required). Build on the platform you target;
  on Windows this gives `TheGreatAnalyzer.exe`. The GitHub Actions workflows do this for
  Windows, macOS and Linux on every tag.
- `tools/build_windows_package.sh` builds the portable Windows package **on Linux**: `The Great Analyzer.exe` (a small
  native launcher, `tools/windows/launcher.c`, compiled with mingw-w64), the application, Gson and the Windows JavaFX modules
  from Maven Central, and a Windows Java 25 runtime (Eclipse Temurin, repackaged on PyPI as `jdk4py`). Result:
  `build/windows/The-Great-Analyzer-windows-x64.zip`.

### Windows package details

- `The Great Analyzer.exe` starts `runtime\bin\javaw.exe` with the application on the module path, from the exe's own folder
  (so `path.txt`, which remembers your paths, is kept there).
- `The Great Analyzer.cfg` takes extra Java options, one per line; for example `-Xmx6g` for very large modded saves.
- `The Great Analyzer (with console).bat` starts the same thing with a console window, so error messages stay visible.

### Test data

`tools/make_synthetic_campaign.py OUT_DIR` writes a minimal game directory and a 15-save synthetic campaign
(1836 to 1850) in the save-game syntax, with wars, occupations, a province transfer and an annexation;
`--large` makes a world at real-game scale (about 2,600 provinces) for performance checks, `--small` the unit-test
fixture. `./gradlew screenshots -Pcampaign=OUT_DIR -Pshots=SHOTS_DIR` renders every tab and window to PNG
(use `xvfb-run` on a headless machine).

## Troubleshooting

- **Can't load large late game file**

    The launchers allow 3 GB of heap. In the Windows package add a line such as `-Xmx6g` to `The Great Analyzer.cfg`;
    for jpackage builds change `jlink.launcher.jvmArgs` in `build.gradle`.

- **Accented names look wrong**

    Saves and localisation are read as Windows-1252, as the game writes them. If a mod uses another encoding,
    names may still look odd; figures are unaffected.

## Credits

Typefaces: Old Standard TT (Alexey Kryukov) and IM FELL English SC (Igino Marini), both under the SIL Open Font
Licence; licence texts in `src/main/resources/fonts`. Save parsing uses EUGFile.

## To do list:

- [x] Upload jar files
- [x] Test with different environments
- [x] Improve architecture and code quality
- [x] Implement continuous watching for game history
- [x] Display or export game history
