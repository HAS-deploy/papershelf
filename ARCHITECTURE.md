# PaperShelf — Architecture (Stage 1)

## Stack
SwiftUI · SwiftData · VisionKit · Vision OCR · PDFKit · StoreKit 2 · LocalAuthentication  
**Third-party dependencies: none**

## Core path
Scan/Import → `ScanPipeline` (OCR → title → category → page JPEG + PDF on disk → SwiftData) → Archive/Search → Detail → Share Sheet

## Monetization
Free: 20 documents. Unlimited: `com.papershelf.app.unlimited.yearly` ($19.99/yr) + `com.papershelf.app.unlimited.lifetime` ($39.99). Paywall includes 3.1.2(a) yearly disclosures + Privacy/Terms links + Restore.

## Explicitly out of V1
Accounts, backend, GPT, PostHog/analytics SDKs, chat/RAG, Drive, folders/tags.
