from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import random
import time

app = FastAPI(title="AI Inference API", version="1.0.0")

class InferenceRequest(BaseModel):
    input_data: str  # Could be base64 image or text prompt

class InferenceResponse(BaseModel):
    label: str
    confidence: float
    processing_time: float

# Mock AI Model (TinyLlama or ResNet50 equivalent simulation)
LABELS = ["cat", "dog", "car", "airplane", "neural_network"]

@app.get("/")
def health_check():
    return {"status": "healthy", "service": "AI Inference Server"}

@app.post("/predict", response_model=InferenceResponse)
def predict(request: InferenceRequest):
    start_time = time.time()
    
    # Simulate GPU inference latency
    # In a real scenario, this would load the model onto the GPU
    time.sleep(0.15) 
    
    # Dummy logic: Hash the input to get a consistent "prediction"
    seed = sum(ord(c) for c in request.input_data)
    random.seed(seed)
    
    prediction = random.choice(LABELS)
    confidence = round(random.uniform(0.75, 0.99), 4)
    
    processing_time = round(time.time() - start_time, 4)
    
    return {
        "label": prediction,
        "confidence": confidence,
        "processing_time": processing_time
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
