# -*- coding: utf-8 -*-
"""model_loader

Automatically generated by Colab.

Original file is located at
    https://colab.research.google.com/drive/10JvVzrRfpiomhp0_19uUfEIL8ZmKgz-Y
"""


from transformers import AutoTokenizer, AutoModelForCausalLM, pipeline, BitsAndBytesConfig

def load_model_and_tokenizer(model_name="mistralai/Mistral-7B-Instruct-v0.2", quantized=True):
    """
    Load a model and tokenizer.
    Use 4-bit quantization safely with BitsAndBytesConfig if quantized=True.
    """
    if quantized:
        quantization_config = BitsAndBytesConfig(
            load_in_4bit=True,
            bnb_4bit_compute_dtype="float16",   # or "float32" if needed
            bnb_4bit_use_double_quant=True,
            bnb_4bit_quant_type="nf4"
        )
        model = AutoModelForCausalLM.from_pretrained(
            model_name,
            #token = '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',
            quantization_config=quantization_config,
            device_map="auto"
        )
    else:
        model = AutoModelForCausalLM.from_pretrained(model_name, device_map="auto")

    tokenizer = AutoTokenizer.from_pretrained(model_name, force_download=True)

    return tokenizer, model