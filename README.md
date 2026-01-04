# rpa-housing

<div align="center">

![GitHub Release](https://img.shields.io/github/v/release/RP-Alpha/rpa-housing?style=for-the-badge&logo=github&color=blue)
![GitHub commits](https://img.shields.io/github/commits-since/RP-Alpha/rpa-housing/latest?style=for-the-badge&logo=git&color=green)
![License](https://img.shields.io/github/license/RP-Alpha/rpa-housing?style=for-the-badge&color=orange)
![Downloads](https://img.shields.io/github/downloads/RP-Alpha/rpa-housing/total?style=for-the-badge&logo=github&color=purple)

**Shell-Based Property System**

</div>

---

## ✨ Features

- 🏠 **Buy/Sell** - Purchase properties via Target
- 🏗️ **Shell Spawning** - Instanced interiors
- 🚪 **Entry/Exit** - Seamless teleportation
- 🔐 **Permission System** - Admin property management
- ⚙️ **Configurable** - Easy to add new properties

---

## 📦 Dependencies

- `rpa-lib` (Required)
- `oxmysql` (Required)
- Shell/interior resource (e.g., `basic-interiors`)

---

## 📥 Installation

1. Download the [latest release](https://github.com/RP-Alpha/rpa-housing/releases/latest)
2. Ensure you have a shell/interior resource installed
3. Import the database:
   ```sql
   source sql/install.sql
   ```
4. Extract to your `resources` folder
5. Add to `server.cfg`:
   ```cfg
   ensure rpa-lib
   ensure rpa-housing
   ```

---

## 🗄️ Database Setup

The `rpa_housing` table stores property ownership and data.

---

## ⚙️ Configuration

```lua
Config.Houses = {
    ['house1'] = {
        label = "Starter House",
        coords = vector3(x, y, z),
        price = 50000,
        shell = 'basic_apartment'
    }
}
```

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

<div align="center">
  <sub>Built with ❤️ by <a href="https://github.com/RP-Alpha">RP-Alpha</a></sub>
</div>
