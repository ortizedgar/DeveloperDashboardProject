interface Article {
    title: string;
    description: string;
    url: string;
}

interface NewsData {
    news: {
        articles: Array<Article>;
    };
}

export type {NewsData, Article};