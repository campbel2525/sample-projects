/**
 * AI から返ってくる単一の命令オブジェクトの型
 */
export type AiSingleInstruction =
  | { goto: string }
  | { click: string }
  | { fill: { selector: string; text: string } }
  | { wait: number }
  | { screenshot: boolean }
  | { done: boolean }

/**
 * AI から返ってくる命令オブジェクトの型（複数操作対応）
 */
export type AiInstruction = AiSingleInstruction[]

export type ChatMessage = {
  role: 'human' | 'assistant' | 'system'
  content:
    | string
    | (
        | { type: 'text'; text: string }
        | { type: 'image_url'; image_url: { url: string } }
      )[]
}
