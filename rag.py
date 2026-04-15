import glob
from pathlib import Path
from langchain_community.vectorstores import FAISS
from langchain_ollama import OllamaEmbeddings, OllamaLLM
from langchain_text_splitters import CharacterTextSplitter
from langchain_community.document_loaders import TextLoader
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.runnables import RunnablePassthrough
from langchain_core.output_parsers import StrOutputParser

from langchain_text_splitters import RecursiveCharacterTextSplitter

# ---------- 設定 ----------
EMBED_MODEL = "bge-m3"
LLM_MODEL = "gemma4"
DOC_PATTERN = "temp"
QUERY = ""
QUERY_FILE = "q.txt"  # 質問ファイル名

# ---------- 質問の読み込み ----------
if Path(QUERY_FILE).exists():
    QUERY = Path(QUERY_FILE).read_text(encoding="utf-8").strip()
else:
    print(f"⚠️ {QUERY_FILE} が見つかりません。デフォルトの質問を使用します。")
    QUERY = "犬は？"

if not QUERY:
    print("⚠️ 質問ファイルが空です。")
    exit()

# ---------- ドキュメント読み込み ----------
file_paths = glob.glob(DOC_PATTERN)
all_docs = []
for path in file_paths:
    loader = TextLoader(path, encoding="utf-8")
    docs = loader.load()
    for doc in docs:
        doc.metadata["source"] = path
    all_docs.extend(docs)

print(f"✅ 読み込んだファイル数: {len(file_paths)}")

# ---------- 分割処理 ----------
#splitter = CharacterTextSplitter(chunk_size=500, chunk_overlap=50)
splitter = RecursiveCharacterTextSplitter(
    chunk_size=500,
    chunk_overlap=100
)
split_docs = splitter.split_documents(all_docs)
print(f"✅ チャンク数: {len(split_docs)}")

# ---------- ベクトルストア作成 ----------
embedder = OllamaEmbeddings(model=EMBED_MODEL)
vectorstore = FAISS.from_documents(split_docs, embedder)
retriever = vectorstore.as_retriever(search_kwargs={"k": 5})


# ---------- RAG チェーン構築 (LCEL) ----------
llm = OllamaLLM(model=LLM_MODEL)

# 文脈を結合するヘルパー関数
def format_docs(docs):
    return "\n\n".join(doc.page_content for doc in docs)

# プロンプトの定義
template = """以下の文脈のみを使用して質問に答えてください。
文脈: {context}
質問: {question}
回答:"""
prompt = ChatPromptTemplate.from_template(template)

# retriever自体をチェーンに組み込み、docsを保持できるようにします
from langchain_core.runnables import RunnableParallel

# RunnableParallel を使って、回答とソースドキュメントを両方取得できるようにする
rag_chain_with_source = RunnableParallel(
    {"context_docs": retriever, "question": RunnablePassthrough()}
).assign(
    answer=(
        lambda x: {
            "context": format_docs(x["context_docs"]),
            "question": x["question"]
        }
    )
    | prompt
    | llm
    | StrOutputParser()
)

# --- (中略: Ollama再起動処理など) ---

# ---------- 問い合わせ ----------
print(f"\n❓ 質問: {QUERY}")
# 実行結果は辞書形式になります
output = rag_chain_with_source.invoke(QUERY)



"""
# ---------- 出力 ----------
print("\n🔎 検索結果 (ソース):")
for i, doc in enumerate(output["context_docs"]):
    source_name = doc.metadata.get("source", "不明")
    print(f"--- [Chunk {i+1}] (Source: {source_name}) ---")
    print(doc.page_content[:200] + "..." if len(doc.page_content) > 200 else doc.page_content)
    print("-" * 30)
"""



print("\n🧠 回答:\n", output["answer"])

# ファイル保存
formatted_output = f"# 質問\n{QUERY}\n\n# 回答\n{output['answer']}"

'''
参照ソース\n"
for doc in output["context_docs"]:
    formatted_output += f"- {doc.metadata.get('source')}: {doc.page_content}\n"
'''

Path("output.md").write_text(formatted_output, encoding="utf-8")
