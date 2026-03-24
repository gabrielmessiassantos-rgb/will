export interface ItemCarrinho {
  id: string;
  texto: string;
  cor: "Branca" | "Preta" | "Azul" | "Vermelha" | "Verde" | "Amarela";
  tamanho: "P" | "M" | "G" | "GG";
  preco: number;
}

export interface Pedido {
  id: string;
  items: ItemCarrinho[];
  total: number;
  status: "pendente" | "processando" | "enviado" | "entregue" | "cancelado";
  criadoEm: Date;
  atualizadoEm: Date;
}

export interface PagamentoPixData {
  qrCode: string;
  copyPaste: string;
  expiration: number;
}

export interface PagamentoMercadoPago {
  id: string;
  status: string;
  transactionAmount: number;
  description: string;
}

export interface CarrinhoContexto {
  items: ItemCarrinho[];
  total: number;
  adicionarItem: (item: Omit<ItemCarrinho, 'id'>) => void;
  removerItem: (id: string) => void;
  limparCarrinho: () => void;
  atualizarItem: (id: string, item: Partial<ItemCarrinho>) => void;
}
