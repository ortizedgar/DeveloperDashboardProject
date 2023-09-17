import React, { FC } from "react";
import {Article} from "@/types/NewsData";

type NewsCardProps = {
    article: Article;
};

const NewsCard: FC<NewsCardProps> = ({ article: { title, description, url } }) => (
    <article className="bg-white rounded-xl shadow-md overflow-hidden mx-auto mb-4 sm:mb-6 md:mb-8 max-w-md sm:max-w-lg md:max-w-2xl">
        <header className="px-6 py-4">
            <h1 className="text-lg md:text-xl lg:text-2xl font-semibold text-gray-900">{title}</h1>
        </header>
        <section className="prose prose-lg text-gray-600 p-6">
            <span>{description}</span>
        </section>
        <footer className="px-6 pt-4 pb-2">
            <a href={url} className="text-blue-500 hover:underline">
                Read more
            </a>
        </footer>
    </article>
);

export default NewsCard;
