import React, { FC } from "react";
import { GitHubEvent } from "@/types";

interface GithubEventCardProps {
    event: GitHubEvent;
}

const GithubEventCard: FC<GithubEventCardProps> = ({ event: { event_type, payload } }) => (
    <section className="bg-white shadow-md rounded-lg p-4 mb-6 sm:p-6 lg:p-8">
        <h1 className="text-2xl font-semibold mb-4">{event_type}</h1>
        <ul className="list-disc pl-5 space-y-2">
            {payload?.commits?.map(({ message }, index) => (
                <li key={index} className="text-base sm:text-lg">
                    {message}
                </li>
            ))}
        </ul>
    </section>
);

export default GithubEventCard;
