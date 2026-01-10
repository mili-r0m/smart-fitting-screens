import os 

ENV = os.getenv("ENV", "dev") # dev / prod

IS_DEV = ENV == "dev"

# en nuestra pc -> dev
# en produ -> prod