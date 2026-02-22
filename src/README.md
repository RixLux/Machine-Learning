# Setting python project using venv

### Phase 1: The Terminal 

Open your terminal and navigate to where you want your project to live.

1. **Create the Project Folder:**
```bash
mkdir my_data_project
cd my_data_project

```

> project folder name could be anything you want

2. **Create the Virtual Environment (`venv`):**

This creates a folder named `env` that acts as an isolated container for your libraries.
```bash
python3 -m venv env

```

> feel free to change env to your desired name

3. **Activate the Environment:**

You must do this every time you start a new terminal session for this project.
* **Linux/Mac:**
* ```source env/bin/activate```
*(Once activated, you’ll usually see `(env)` appear before your prompt.)*

if you are done 
```bash
deactivate
```

4. **Install Your Libraries:**

For example :

```bash
pip install pandas scipy numpy matplotlib scikit-learn ipykernel

```

> this library is widely used for machine learning, feel free to add any library you might need in the future.

*Note: `ipykernel` is the important part that lets this environment talk to Jupyter.*

---

### Phase 2: Connecting to Jupyter

Now that your environment has the libraries, you need to tell Jupyter to use this specific environment as a **Kernel**.

Run this command while your environment is **activated**:

```bash
python -m ipykernel install --user --name=my_data_env --display-name "Python (Data Science Project)"

```

> Feel free to change my_data_env and Python (Data Science Project) to whatever you want

---

### Phase 3: Launching & Working

feel free to get jupyter notebook from whereever you want  

> p.s. Like from brew for example :)  

If you ever delete the ML_env folder or finish the project, that name will still show up in Jupyter as a "ghost" option. You can remove it by running:  

```bash
jupyter kernelspec uninstall my_data_env
```
