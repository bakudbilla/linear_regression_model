import os
from fastapi import FastAPI
import numpy as np
import pandas as pd
from joblib import load
from pydantic import BaseModel, Field
from fastapi.middleware.cors import CORSMiddleware
import uvicorn



class PredictInput(BaseModel):
    age: float = Field(..., ge=0, le=120, description="Age must be between 0 and 120")
    sex: bool  # True = male, False = female
    bmi: float = Field(..., ge=10, le=50, description="BMI must be between 10 and 50")
    children: int = Field(..., ge=0, le=20, description="Number of children must be between 0 and 20")
    smoker: bool  # True if smoker, False otherwise


app = FastAPI()

#CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# loading the model
decision_model = load("decisiontrees.pkl")


@app.get("/")
def root():
    return {"message": "Welcome to MedInsure"}


@app.post("/predict")
def predict(data: PredictInput):
    
    sex = 1 if data.sex else 0
    smoker = 1 if data.smoker else 0

   
    # input_values = np.array([
    #     data.age,
    #     sex,
    #     data.bmi,
    #     data.children,
    #     smoker
    # ]).reshape(1, -1)

    input_values = pd.DataFrame([{
        "age": data.age,
        "sex": sex,
        "bmi": data.bmi,
        "children": data.children,
        "smoker": smoker
    }])




    try:
      
        prediction = decision_model.predict(input_values)
        return {"predicted_charges": prediction[0]}
    except Exception as e:
        return {"error": str(e)}


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 10000))
    uvicorn.run(app, host="0.0.0.0", port=port)
