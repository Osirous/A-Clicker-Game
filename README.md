# 🎮 A Clicker Game – Client

Frontend client for **A Clicker Game server**. 

This client can run **standalone** (without a server) or connect to a backend server for persistent storage and multiplayer features.

🖥 **Server Repository (optional):**  
👉 https://github.com/Osirous/A-Clicker-Game-server  

> Currently, the server connection is hardcoded to `localhost:8080`.

---

# 🧩 Project Overview

- Standalone mode: all game logic runs in the client; no server required.  
- Server mode: stores player progress and handles authentication through the backend.  
- Game mechanics: clicker-style gameplay, upgrades, and stats.  

---

# 📁 Project Structure

A-Clicker-Game/
├── src/ # Game source code
├── assets/ # Images, sounds, etc.
├── project.godot # Godot project file
├── README.md
└── ... # other engine-specific files

---

# 🔧 Requirements

- **Godot Engine** (current project built in Godot)  
- Optional: **A running server** (`A Clicker Game Server`) if you want to use server features.

---

# 🔌 Server Connection (Optional)

If you want the client to connect to a backend server:

1. Clone and start the server:  
   https://github.com/Osirous/A-Clicker-Game-server
2. Ensure the server is running on `localhost:8080`.
3. The client will automatically use this address.  
   (Currently, the server URL is hardcoded; future updates may make it configurable.)

---

# ▶️ Running the Client

1. Open the project in **Godot Engine**.  
2. Press **Play** or build the project.  
3. You can play in **standalone mode** or connect to the backend for server features.

---

# 🤝 Contributing

Pull requests welcome:

- UI improvements  
- Game mechanics enhancements  
- Server integration
