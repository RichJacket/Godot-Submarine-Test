Usage:
- Install Python (used Python 3.14.4)
- Create and activate a `venv` and run `pip install godot-rl` (used 0.8.2)
- Run `stable_baselines3_example.py` from terminal

Arguments for the Python script:
- `--env_path=path\to\env.exe` - Path to the environment executable
- `--experiment_name="name"` - Name for the save folder of the experiment (will be saved under `venv\logs\sb3\name`, if an experiment with that name already exists training cannot be run)
- `--n_parallel=X` - Run X models in parallel for training (used 8)
- `--speedup=X` - Run the physics at X times speed to increase speed of training (used 4)
- `--learning_rate X` - Learning rate for the NN (used 0.0001)
- `--timesteps=X` - Amount of timesteps to train for / for inference (used 10 000 000, replace spaces with underscores(!!!))
- `--save_checkpoint_frequency=50_000` - Checkpoint save interval in timesteps (used 50 000, replace spaces with underscores(!!!))
- `--inference` - Infer model from checkpoints saved in `--experiment_name` folder
- `--viz` - Run environment visually, slower training but shows results well when inference is running
