clear all
clc

% Leitura dos dados
camargos = load('data/Camargos.txt');
furnas   = load('data/Furnas.txt');

camargos_linha = reshape(camargos', 1, []);
furnas_linha   = reshape(furnas', 1, []);

inputs  = [];
targets = [];

% Construção dos padrões de entrada (3 atrasos) e saída (3 passos à frente)
for i = 1:(82*12 - 5)
    entrada = [camargos_linha(i:i+2)'; furnas_linha(i:i+2)'];
    saida   = [camargos_linha(i+3:i+5)'; furnas_linha(i+3:i+5)'];
    
    inputs  = [inputs entrada];
    targets = [targets saida];
end

% Definição da arquitetura e configuração inicial
net = feedforwardnet(5);
%net = feedforwardnet([15 5 15]);
%net = feedforwardnet(15);
%net = feedforwardnet(100);
%net = feedforwardnet(50);
%net = feedforwardnet([4 4]);

net = configure(net, inputs, targets);
net = init(net);

% Divisão dos dados
net.divideFcn = 'dividerand';
net.divideParam.trainRatio = 0.7;
net.divideParam.valRatio   = 0.15;
net.divideParam.testRatio  = 0.15;

% Configurações do treinamento
net.trainFcn = 'trainlm';
%net.trainFcn = 'trainrp';
%net.trainFcn = 'traincgp';
%net.trainFcn = 'trainbr';

net.layers{1}.transferFcn = 'tansig';
net.layers{2}.transferFcn = 'purelin';
net.performFcn = 'mse';

net.trainParam.showWindow = true;
net.trainParam.epochs     = 1e6;
net.trainParam.time       = 600;
net.trainParam.lr         = 0.2;
net.trainParam.min_grad   = 1e-18;
net.trainParam.max_fail   = 1000;

[net, tr] = train(net, inputs, targets);

% Dados reais para comparação
xP = 1:(81*6);
xF = (81*6+1):(82*6);
XriosP = [];

for i = 1:81
    ent = [camargos(i, 1:3), furnas(i, 1:3)];
    XriosP = [XriosP ent];
end

xriosF = [camargos(82, 1:3), furnas(82, 1:3)];

% Plot dos dados reais
figure;
plot(xP, XriosP, 'b', 'DisplayName', 'Valores Dados');
hold on;
plot(xF, xriosF, 'r', 'DisplayName', 'Valores Esperados');
xlabel('Meses');
ylabel('Vazão');
title('Vazão dos Rios Camargos e Furnas');
grid on;

% Simulação da rede
xS  = 1:(82*6);
PsA = [camargos(1, 1:3)'; furnas(1, 1:3)'];
Ms  = PsA;

for i = 1:81
    PsD = sim(net, PsA);
    Ms  = [Ms, PsD];
    PsA = PsD;
end

% Organiza os dados simulados para plot
yS = [];

for i = 1:size(Ms, 2)
    yS = [yS Ms(:, i)'];
end

% Plot dos resultados simulados
plot(xS, yS, ':m', 'LineWidth', 1.5, 'DisplayName', 'Resultados');
legend();
hold off;
