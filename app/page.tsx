"use client";

import { useState } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { motion } from "framer-motion";

interface ItemCarrinho {
  id: string;
  texto: string;
  cor: string;
  tamanho: string;
  preco: number;
}

export default function WillDTFStore() {
  const [texto, setTexto] = useState("");
  const [cor, setCor] = useState("Branca");
  const [tamanho, setTamanho] = useState("M");
  const [carrinho, setCarrinho] = useState<ItemCarrinho[]>([]);

  const adicionarCarrinho = () => {
    if (!texto.trim()) {
      alert("Por favor, digite uma estampa válida!");
      return;
    }

    const item: ItemCarrinho = {
      id: `${Date.now()}-${Math.random()}`,
      texto,
      cor,
      tamanho,
      preco: 59.9,
    };

    setCarrinho([...carrinho, item]);
    setTexto("");
  };

  const removerDoCarrinho = (id: string) => {
    setCarrinho(carrinho.filter((item) => item.id !== id));
  };

  const total = carrinho.reduce((acc, item) => acc + item.preco, 0);

  const finalizarCompra = () => {
    if (carrinho.length === 0) return;
    
    alert(
      `Pedido confirmado!\n\nTotal: R$ ${total.toFixed(2)}\nQuantidade: ${carrinho.length} camiseta(s)\n\nEm breve você será redirecionado para o Mercado Pago.`
    );
    setCarrinho([]);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 to-slate-100 p-6">
      <div className="max-w-5xl mx-auto grid gap-6">
        {/* Header */}
        <motion.div
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5 }}
          className="text-center"
        >
          <h1 className="text-5xl font-bold text-slate-900">WILL DTF</h1>
          <p className="text-lg text-slate-600 mt-2">
            Camisetas Personalizadas Profissionais
          </p>
        </motion.div>

        {/* Layout Grid */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Criador */}
          <motion.div
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.5, delay: 0.1 }}
          >
            <Card className="shadow-xl">
              <CardContent className="grid gap-6 pt-6">
                <div>
                  <h2 className="text-2xl font-semibold text-slate-900">
                    Crie sua camiseta
                  </h2>
                  <p className="text-sm text-slate-500 mt-1">
                    Personalize com sua frase, nome ou meme
                  </p>
                </div>

                <Input
                  placeholder="Digite sua estampa (ex: frase, nome, meme)"
                  value={texto}
                  onChange={(e) => setTexto(e.target.value)}
                  onKeyPress={(e) => {
                    if (e.key === "Enter") adicionarCarrinho();
                  }}
                  className="text-base"
                />

                <div className="grid grid-cols-2 gap-4">
                  <div className="grid gap-2">
                    <label className="text-sm font-medium text-slate-700">
                      Cor
                    </label>
                    <select
                      className="p-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-slate-500 focus:border-transparent"
                      value={cor}
                      onChange={(e) => setCor(e.target.value)}
                    >
                      <option>Branca</option>
                      <option>Preta</option>
                      <option>Azul</option>
                      <option>Vermelha</option>
                      <option>Verde</option>
                      <option>Amarela</option>
                    </select>
                  </div>

                  <div className="grid gap-2">
                    <label className="text-sm font-medium text-slate-700">
                      Tamanho
                    </label>
                    <select
                      className="p-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-slate-500 focus:border-transparent"
                      value={tamanho}
                      onChange={(e) => setTamanho(e.target.value)}
                    >
                      <option>P</option>
                      <option>M</option>
                      <option>G</option>
                      <option>GG</option>
                    </select>
                  </div>
                </div>

                <div className="pt-4 grid gap-2">
                  <p className="text-lg font-semibold text-slate-900">
                    R$ 59,90
                  </p>
                  <Button
                    onClick={adicionarCarrinho}
                    className="w-full h-11 bg-slate-900 hover:bg-slate-800 text-white font-semibold"
                  >
                    Adicionar ao carrinho
                  </Button>
                </div>
              </CardContent>
            </Card>
          </motion.div>

          {/* Carrinho */}
          <motion.div
            initial={{ opacity: 0, x: 20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.5, delay: 0.2 }}
          >
            <Card className="shadow-xl">
              <CardContent className="grid gap-4 pt-6">
                <div>
                  <h2 className="text-2xl font-semibold text-slate-900">
                    Carrinho
                  </h2>
                  <p className="text-sm text-slate-500 mt-1">
                    {carrinho.length} item(ns)
                  </p>
                </div>

                <div className="space-y-3 max-h-80 overflow-y-auto">
                  {carrinho.length === 0 ? (
                    <div className="text-center py-8 text-slate-500">
                      <p className="text-base">Seu carrinho está vazio.</p>
                      <p className="text-sm mt-2">
                        Adicione camisetas para começar!
                      </p>
                    </div>
                  ) : (
                    carrinho.map((item, index) => (
                      <motion.div
                        key={item.id}
                        initial={{ opacity: 0, y: 10 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ delay: index * 0.05 }}
                        className="p-4 border border-slate-200 rounded-lg bg-slate-50 hover:bg-slate-100 transition"
                      >
                        <div className="flex justify-between items-start gap-3">
                          <div className="flex-1 grid gap-2">
                            <p className="font-semibold text-slate-900">
                              {item.texto}
                            </p>
                            <div className="text-sm text-slate-600 space-y-1">
                              <p>
                                <strong>Cor:</strong> {item.cor}
                              </p>
                              <p>
                                <strong>Tamanho:</strong> {item.tamanho}
                              </p>
                            </div>
                            <p className="font-bold text-slate-900 pt-1">
                              R$ {item.preco.toFixed(2)}
                            </p>
                          </div>
                          <Button
                            variant="outline"
                            size="sm"
                            onClick={() => removerDoCarrinho(item.id)}
                            className="bg-red-50 hover:bg-red-100 text-red-600 border-red-200"
                          >
                            Remover
                          </Button>
                        </div>
                      </motion.div>
                    ))
                  )}
                </div>

                {carrinho.length > 0 && (
                  <div className="border-t border-slate-200 pt-4 grid gap-3 mt-4">
                    <div className="flex justify-between items-center">
                      <p className="text-slate-600">Subtotal:</p>
                      <p className="font-semibold text-slate-900">
                        R$ {total.toFixed(2)}
                      </p>
                    </div>
                    <div className="flex justify-between items-center pb-3 border-b border-slate-200">
                      <p className="text-slate-600">Frete:</p>
                      <p className="font-semibold text-green-600">Grátis</p>
                    </div>
                    <div className="flex justify-between items-center">
                      <p className="text-lg font-bold text-slate-900">Total:</p>
                      <p className="text-2xl font-bold text-slate-900">
                        R$ {total.toFixed(2)}
                      </p>
                    </div>

                    <Button
                      className="w-full h-11 bg-green-600 hover:bg-green-700 text-white font-semibold mt-2"
                      onClick={finalizarCompra}
                    >
                      Finalizar Pedido (Pix)
                    </Button>

                    <Button
                      variant="outline"
                      className="w-full h-11 font-semibold"
                    >
                      Pagar com Cartão (em breve)
                    </Button>
                  </div>
                )}
              </CardContent>
            </Card>
          </motion.div>
        </div>

        {/* Rodapé */}
        <footer className="text-center text-sm text-slate-500 py-8 border-t border-slate-200 mt-8">
          <p>© 2026 WILL DTF - Todos os direitos reservados</p>
          <p className="mt-2">
            Feito com ❤️ por Gabriel Messias
          </p>
        </footer>
      </div>
    </div>
  );
}
