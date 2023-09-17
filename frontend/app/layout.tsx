import './globals.css'
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import React, {ReactNode} from "react";

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Developer Dashboard',
  description: 'ToDo...',
}

export default function RootLayout({
  children,
}: {
  children: ReactNode
}) {
  return (
    <html lang="en">
      <body className={inter.className}>{children}</body>
    </html>
  )
}
