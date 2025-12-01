"""
Test script for AI explanation features
"""
import requests
import json

API_BASE = "http://localhost:8000"

def test_explanation_english():
    print("🧪 Testing AI Explanation (English)...")
    print("=" * 60)
    
    payload = {
        "section_text": "Whoever commits murder shall be punished with death or imprisonment for life, and shall also be liable to fine.",
        "language": "en",
        "include_examples": True
    }
    
    try:
        response = requests.post(f"{API_BASE}/api/explain", json=payload)
        response.raise_for_status()
        result = response.json()
        
        print("\n📝 Simple Explanation:")
        print(result.get("simple_explanation", "N/A"))
        
        if result.get("examples"):
            print("\n💡 Examples:")
            print(result["examples"])
        
        print("\n✅ Test passed!")
        return True
    except Exception as e:
        print(f"\n❌ Test failed: {e}")
        return False


def test_explanation_hindi():
    print("\n\n🧪 Testing AI Explanation (Hindi)...")
    print("=" * 60)
    
    payload = {
        "section_text": "जो कोई हत्या करेगा वह मृत्युदंड या आजीवन कारावास से दंडित किया जाएगा",
        "language": "hi",
        "include_examples": True
    }
    
    try:
        response = requests.post(f"{API_BASE}/api/explain", json=payload)
        response.raise_for_status()
        result = response.json()
        
        print("\n📝 सरल व्याख्या:")
        print(result.get("simple_explanation", "N/A"))
        
        if result.get("examples"):
            print("\n💡 उदाहरण:")
            print(result["examples"])
        
        print("\n✅ टेस्ट पास हुआ!")
        return True
    except Exception as e:
        print(f"\n❌ टेस्ट विफल: {e}")
        return False


def test_chat():
    print("\n\n🧪 Testing AI Chat...")
    print("=" * 60)
    
    payload = {
        "question": "What are my rights if police stops me?",
        "language": "en"
    }
    
    try:
        response = requests.post(f"{API_BASE}/api/chat", json=payload)
        response.raise_for_status()
        result = response.json()
        
        print("\n💬 Answer:")
        print(result.get("answer", "N/A"))
        
        print(f"\n⚠️ Disclaimer: {result.get('disclaimer', 'N/A')}")
        
        print("\n✅ Test passed!")
        return True
    except Exception as e:
        print(f"\n❌ Test failed: {e}")
        return False


def test_health():
    print("🧪 Testing Health Endpoint...")
    try:
        response = requests.get(f"{API_BASE}/health")
        if response.json()["status"] == "ok":
            print("✅ Backend is healthy!")
            return True
    except Exception as e:
        print(f"❌ Backend not reachable: {e}")
        return False


if __name__ == "__main__":
    print("\n🚀 Starting AI Features Test Suite")
    print("=" * 60)
    
    if not test_health():
        print("\n⚠️ Make sure backend is running: cd backend && python run_server.bat")
        exit(1)
    
    print()
    test_explanation_english()
    test_explanation_hindi()
    test_chat()
    
    print("\n" + "=" * 60)
    print("🎉 All tests completed!")
