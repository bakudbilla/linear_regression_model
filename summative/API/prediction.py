import os
from fastapi import FastAPI
import numpy as np
import uvicorn
from joblib import load
from pydantic import BaseModel


class PredictInput(BaseModel):
    age: float
    sex: bool
    bmi: float
    children: int
    smoker: bool

app = FastAPI()


decision_model = load("decisiontrees.pkl")

@app.get("/")
def root():
    return {"Welcome": "to MedInsure"}

@app.post("/predict")
def predict(data: PredictInput):
    
    sex = 1 if data.sex else 0
    smoker = 1 if data.smoker else 0
    
    
    input_values = np.array([
        data.age,
        sex,  
        data.bmi,
        data.children,
        smoker  
    ]).reshape(1, -1)
    
    try:
        
        prediction = decision_model.predict(input_values)
        
        return {"predicted charges": prediction[0]}  
    except Exception as e:
        return {"error": str(e)}
# if __name__ == "__main__":
#    port = int(os.environ.get("PORT", 10000))
#     uvicorn.run(app, host="0.0.0.0", port=port)