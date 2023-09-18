import NewsCard from '../components/NewsCard';
import GithubEventCard from '../components/GithubEventCard';
import React, {FC} from "react";
import {GitHubEventsData, NewsData} from "@/types";

type DashboardServerProps = {
    eventsData: GitHubEventsData | undefined;
    newsData: NewsData | undefined;
    fetchNews: () => void;
};

const DashboardServer: FC<DashboardServerProps> = ({newsData, eventsData, fetchNews}) => (
    <div className="flex flex-col md:flex-row justify-between">
        <section className="md:w-1/2 p-4">
            <div className="flex justify-between items-center mb-4">
                <h2 className="text-xl font-semibold">News</h2>
                <button onClick={fetchNews} className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
                    Fetch News
                </button>
            </div>
            {newsData?.news.articles.length ? (
                newsData?.news.articles.map((article, index) => (
                    <NewsCard key={index} article={article} />
                ))
            ) : (
                <div className="text-gray-500">
                    <p>No news available. Please press the "Fetch News" button to load the news.</p>
                </div>
            )}
        </section>
        <section className="md:w-1/2 p-4">
            <h2 className="text-xl font-semibold mb-4">GitHub Events</h2>
            {eventsData?.events.map((event, index) => (
                <GithubEventCard key={index} event={event}/>
            ))}
        </section>
    </div>
);

export default DashboardServer;
