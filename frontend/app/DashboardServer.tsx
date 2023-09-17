import NewsCard from '../components/NewsCard';
import GithubEventCard from '../components/GithubEventCard';
import React, { FC } from "react";
import { GitHubEventsData, NewsData } from "@/types";

type DashboardServerProps = {
    eventsData: GitHubEventsData | undefined;
    newsData: NewsData | undefined;
};

const DashboardServer: FC<DashboardServerProps> = ({ newsData, eventsData }) => (
    <main className="container mx-auto px-4 py-8">
        <header className="text-center mb-8">
            <h1 className="text-2xl md:text-3xl lg:text-4xl font-bold text-gray-900">Dashboard</h1>
        </header>
        <section className="mb-12">
            <h2 className="text-xl md:text-2xl font-semibold text-gray-900 mb-4">News</h2>
            <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4">
                {newsData?.news.articles.map((article, index) => (
                    <NewsCard key={index} article={article} />
                ))}
            </div>
        </section>
        <section>
            <h2 className="text-xl md:text-2xl font-semibold text-gray-900 mb-4">GitHub Events</h2>
            <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4">
                {eventsData?.events.map((event, index) => (
                    <GithubEventCard key={index} event={event} />
                ))}
            </div>
        </section>
    </main>
);

export default DashboardServer;
