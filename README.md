# riverflow-forecast-mlp

Previsão da vazão dos rios Camargos e Furnas utilizando redes neurais do tipo MLP (Multilayer Perceptron) com diferentes arquiteturas e algoritmos de treinamento. O projeto utiliza o Toolbox de Redes Neurais do MATLAB e dados históricos para construir uma representação dinâmica com base no modelo NARMAX.

---

## 📊 Visão Geral

A rede neural é treinada com pares de entrada/saída defasados no tempo. São testadas diferentes arquiteturas (como 6-5-6, 6-15-6, 6-100-6) e algoritmos de treinamento (`trainlm`, `trainrp`, `traincgp`, `trainbr`) para prever os próximos valores de vazão com base nos valores passados.

---

## ⚙️ Requisitos

- MATLAB R2018 ou R2022
- Neural Network Toolbox (`feedforwardnet`, `trainlm`, etc.)

---

## 🚀 Como rodar

1. Abra o MATLAB e navegue até a pasta `src/`
2. Execute o script principal:
   ```matlab
   main

