// function middleware(iob, currenttemp, glucose, profile, autosens, meal, reservoir, clock, preferences, basalprofile, oref2_variables) {
    // Ensure the glucose array is not empty and has enough data
    if (glucose.length < 2) {
        return "Not enough data";
    }

    // Calculate glucose percentage changes
    let percentageChanges = [];
    for (let i = 1; i < glucose.length; i++) {
        let delta = Math.abs(glucose[i].glucose - glucose[i - 1].glucose);
        let earlierGlucoseValue = glucose[i - 1].glucose;
        let percentageChange = (delta / earlierGlucoseValue) * 100;

        percentageChanges.push({
            percentageChange: percentageChange.toFixed(2) // rounding to two decimal places for readability
        });
    }

    // Sort the percentage changes to find the top five largest changes
    percentageChanges.sort((a, b) => b.percentageChange - a.percentageChange); // Sort by percentage change in descending order

    // Select the top five
    let topFivePercentageChanges = percentageChanges.slice(0, 5);

    // Format the output to return
    let output = topFivePercentageChanges.map(d => `${d.percentageChange}% change`).join(", ");
    return output;
}
