import type { Metadata } from "next";
import { Poppins } from "next/font/google";
import "./globals.css";

const poppins = Poppins({
  subsets: ["latin"],
  weight: ["300", "400", "500", "600", "700", "900"],
  variable: "--font-poppins",
});

export const metadata: Metadata = {
  title: "WILL DTF - Camisetas Personalizadas",
  description: "Crie suas camisetas personalizadas com estampas profissionais DTF",
  keywords: ["camiseta", "personalizada", "DTF", "loja online"],
  authors: [{ name: "Gabriel Messias" }],
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="pt-BR">
      <body className={`${poppins.variable} font-sans antialiased`}>
        {children}
      </body>
    </html>
  );
}
